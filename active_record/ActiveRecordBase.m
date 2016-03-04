//
//  ActiveRecordBase.m
//  ActiveRecord
//
//  Created by kenny on 5/17/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "ActiveRecordBase.h"
#import <sqlite3.h>
#import "wheel.h"
#import <objc/NSObject.h>
#import <objc/runtime.h>
FMDatabase *_db;
#define kActiveRecordDebugKey "kActiveRecordDebug"
@interface ActiveRecordBase (){
}
@end

@implementation ActiveRecordBase
+ (BOOL) _isDebug{
    return getenv(kActiveRecordDebugKey) != NULL;
}

+ (void)_showErr{
    NSAssert2(NO, @"%@,%@", [_db lastError],_db.lastErrorMessage);
}

+ (BOOL) runSql:(NSString *)sql{
    if ([self _isDebug]) {
        printf("\n----sqlite: %s", sql.UTF8String);
    }
    NSAssert(_db != nil, @"创建连接失败");
    BOOL ok  = [_db executeStatements:sql];
    if (!ok) {
        [self _showErr];
    }
    return ok;
}

+ (NSArray *) getList:(NSString *)sql{
    if ([self _isDebug]) {
        NSLog(@"\nsqlite: %@", sql);
    }
    NSAssert(_db != nil, @"创建连接失败");
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [_db executeQuery:sql];
    while (rs.next) {
        NSDictionary *info = rs.resultDictionary;
        id obj = [[self.class alloc] init];
        for (NSString *key in info) {
            if ([key isEqualToString:@"id"]) {
                [obj setValue:info[key] forKey:@"uniqueId"];
            }else{
                [obj setValue:info[key] forKey:key];
            }
        }
        [result addObject:obj];
    }
    return result;
}

+ (void) connect{
    NSString *name = @"ar.sqlite";
    NSString *documentPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    void (^conncetDb)(void) = ^{
        _db = [FMDatabase databaseWithPath:documentPath];
        _db.logsErrors = YES;
        _db.traceExecution = YES;
#ifdef DEBUG
        BOOL ok = [_db open];
        NSAssert2(ok, @"open出错%@,%@", [_db lastError],_db.lastErrorMessage);
#else
        [_db open];
#endif
    };
    if (![fileManager fileExistsAtPath:documentPath]) {//没在document下面,第一次
        NSString *sqliteFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ar.sqlite"];
        if ([fileManager fileExistsAtPath:sqliteFilePath]) {//有sqlite文件, copy
            [fileManager copyItemAtPath:sqliteFilePath toPath:documentPath error:nil];
            conncetDb();
        }else{
            NSString *sqlFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ar.sql"];
            NSString *sql = [NSString stringWithContentsOfFile:sqlFilePath encoding:NSUTF8StringEncoding error:nil];
            NSParameterAssert(sql.length > 0);
            conncetDb();
            [self runSql:sql];
        }
//        
//        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:documentPath];
//        [queue inDatabase:^(FMDatabase *db){
//            NSString *sqlFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ar.sql"];
//            NSString *sql = [NSString stringWithContentsOfFile:sqlFilePath encoding:NSUTF8StringEncoding error:nil];
//            [db executeStatements:sql];
//        }];

    }else{
        conncetDb();
    }
    NSLog(@"建立连接成功:%@",documentPath);
}

+ (void) disConnect{
    [_db close];
}

+(sqlite_int64) lastInsertId{
        NSAssert(_db != nil, @"创建连接失败");
    return [_db lastInsertRowId];
}

+(NSString *) tableName{
    return [self tableName:self];
}

+ (NSString *) tableName: (Class) klass{
    NSString *modelName = [klass description];
    NSMutableArray *underArr = [NSMutableArray array];
    for (int i =0; i < [modelName length]; i++) {
        //把大写字母弄成_a这种
        const char *c = [[modelName substringWithRange:NSMakeRange(i, 1)] UTF8String];
        if (i == 0) {
            [underArr addObject:[NSString stringWithFormat:@"%c", (*c+32)]];
        }else if (*c < 'a') {//a是97, A是65所以这么比就知道大小写了
            //大写
            [underArr addObject:[NSString stringWithFormat:@"_%c", (*c+32)]];
        }else{
            [underArr addObject:[NSString stringWithUTF8String:c]];
        }
    }
    NSString *tableName = [underArr componentsJoinedByString:@""];
    return [NSString stringWithFormat:@"%@s", tableName];
}

//修改了属性, 更新到数据库, 会把changes清0

- (BOOL) isNewRecord{
    return self.uniqueId == 0;
}

#pragma mark 增
+ (NSString *) _buildSqlValue:(NSArray *)originValue{
    NSMutableArray *values = [NSMutableArray arrayWithArray:originValue];
    for (int i = 0; i < values.count; i++) {
        id value = values[i];
        NSAssert([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class], @"只支持stirng和number");
        if ([value isKindOfClass:NSString.class]) {
            values[i] = [NSString stringWithFormat:@"'%@'",value];
        }
    }
    return [values componentsJoinedByString:@","];
}

+ (instancetype) aRCreate:(NSDictionary *)attributes{
    NSString *sql  = [NSString stringWithFormat:@"INSERT INTO %@ ('%@') VALUES (%@);",
                      [self.class tableName],
                      [attributes.allKeys componentsJoinedByString:@"','"],
                      [self _buildSqlValue:attributes.allValues]
                      ];
    [self runSql:sql];
    return [self find:(int)[self lastInsertId]];
}

+ (NSArray *)aRCreates:(NSArray *)infos{
    NSMutableArray *values = [NSMutableArray array];
    for (NSDictionary *attributes in infos) {
        [values addObject:[self _buildSqlValue:attributes.allValues]];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ('%@') VALUES (%@);",self.class.tableName, [[infos.firstObject allKeys] componentsJoinedByString:@"','"],[values componentsJoinedByString:@"),("]];
    [self runSql:sql];
    return [self where:[NSString stringWithFormat:@"1 ORDER BY id DESC LIMIT %d",(int)infos.count]];
}

+ (void) arReplace :(NSDictionary *)attributes{
    NSString *sql  = [NSString stringWithFormat:@"REPLACE INTO %@ ('%@') VALUES (%@);",
                      [self.class tableName],
                      [attributes.allKeys componentsJoinedByString:@"','"],
                      [self _buildSqlValue:attributes.allValues]
                      ];
    [self runSql:sql];
}

+ (void)arReplaces:(NSArray *)infos{
    NSMutableArray *values = [NSMutableArray array];
    for (NSDictionary *attributes in infos) {
        [values addObject:[self _buildSqlValue:attributes.allValues]];
    }
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ ('%@') VALUES (%@);",self.class.tableName, [[infos.firstObject allKeys] componentsJoinedByString:@"','"],[values componentsJoinedByString:@"),("]];
    [self runSql:sql];
}

#pragma mark删
- (void) destory{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %ld;", [self.class tableName], (long)self.uniqueId];
    [self.class runSql: sql];
}

+(void) destory:(NSString *)where{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@;", [self.class tableName], where];
    [self.class runSql: sql];
}

+ (void) destoryAll{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@;VACUUM; update sqlite_sequence set seq=0 where name='%@';", [self.class tableName],self.class.tableName];
    [self.class runSql: sql];
}
#pragma mark查
+(instancetype) find:(int)_id{
    NSArray *models = [self.class where:[NSString stringWithFormat:@"id = %d",_id]];
    if (models.count > 0) {
        return [models objectAtIndex:0];
    }else{
        NSAssert(NO, @"can't find");
        return nil;
    }
}

+(NSArray *) all{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",[self tableName]];
    return [self getList:sql];
}

+ (NSArray *)where:(id)where{
    NSString *whereStr = nil;
    if ([where isKindOfClass:NSString.class]) {
        whereStr = where;
    }else if([where isKindOfClass:NSDictionary.class]){
        NSMutableArray *conditions = [NSMutableArray array];
        for (NSString *key in (NSDictionary *)where) {
            id value = where[key];
            NSString *condition = @"";
            if ([value isKindOfClass:NSString.class]) {
                condition = [NSString stringWithFormat:@"%@ = '%@'",key,value];
            }else if([value isKindOfClass:NSArray.class]){
                NSMutableArray *tmp = [NSMutableArray array];
                for (id a in (NSArray *)value) {
                    if ([a isKindOfClass:NSString.class]) {
                        [tmp addObject:[NSString stringWithFormat:@"'%@'",a]];
                    }else{
                        [tmp addObject:a];
                    }
                }
                condition = [NSString stringWithFormat:@"%@ IN (%@)",key,[tmp componentsJoinedByString:@","]];
            }else if ([value isKindOfClass:NSNumber.class]){
                condition = [NSString stringWithFormat:@"%@ = %@",key,value];
            }else{
                NSParameterAssert(NO);
            }
            [conditions addObject:condition];
        }
        whereStr = [conditions componentsJoinedByString:@" AND "];
    }
    NSAssert(whereStr.length > 0, @"字符串为空, 不能where");
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE  %@",[self tableName],whereStr];
    return [self getList:sql];
}

+ (instancetype) first{
    NSArray *all = [self getList:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id ASC LIMIT 1;",self.tableName]];
    return all.firstObject;
}
#pragma mark --改--
- (void) updateAttribute:(NSString *)field toValue:(id)value{
    NSString * sql  = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE id = %d;",
            [self.class tableName],
            field,value,
            [self uniqueId]
            ];
    [self.class runSql:sql];
}

- (void) updateAttributes:(NSDictionary *)attributes{
    NSMutableArray *change_strs = [NSMutableArray array];
    for (NSString *key in attributes){
        [change_strs addObject:[NSString stringWithFormat:@"%@ = '%@'", key, attributes[key]]];
    }
    NSString *sql  = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE id = %d;",
            [self.class tableName],
            [change_strs componentsJoinedByString:@","],
            [self uniqueId]
            ];
    [self.class runSql:sql];
}

+ (BOOL) updateAttributes:(NSDictionary *)attributes where:(NSString *)where{
    NSMutableArray *change_strs = [NSMutableArray array];
    for (NSString *key in attributes){
        [change_strs addObject:[NSString stringWithFormat:@"%@ = '%@'", key, attributes[key]]];
    }
    NSString *sql  = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;",
                      [self.class tableName],
                      [change_strs componentsJoinedByString:@","],
                      where
                      ];
    return [self runSql:sql];
}
@end
