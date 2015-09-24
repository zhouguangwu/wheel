//
//  ActiveRecordBase.h
//  ActiveRecord
//
//  Created by kenny on 5/17/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
@interface ActiveRecordBase : NSObject
@property int uniqueId;
//创建连接和关闭连接
+ (void) connect;
+ (void) disConnect;
//基础方法
+ (BOOL) runSql:(NSString *)sql;
+ (NSArray *) getList:(NSString *)sql;
+ (sqlite_int64)lastInsertId;
+ (NSString *) tableName;
+ (NSString *) tableName: (Class) klass;
//把changes, attributes全部清空, 就像刚刚find一样, 如果是newrecord那么就认为是刚insert
- (BOOL) isNewRecord;
//增
+ (instancetype) aRCreate :(NSDictionary *)attributes;
+ (NSArray *)aRCreates:(NSArray *)infos;
+ (void) arReplace :(NSDictionary *)attributes;
+ (void)arReplaces:(NSArray *)infos;
//删
- (void) destory;
+ (void) destory:(NSString *)where;
+ (void) destoryAll;
//查
+ (instancetype)find:(int) _id;
+ (NSArray *)all;
+ (NSArray *)where:(id)where;
+ (instancetype) first;
//改
- (void) updateAttribute:(NSString *)field toValue:(id) value;
- (void) updateAttributes: (NSDictionary *) attributes;
+ (BOOL) updateAttributes:(NSDictionary *)attributes where:(NSString *)where;
@end
