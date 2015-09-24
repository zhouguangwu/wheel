//
//  Cacher.h
//  waimai
//
//  Created by birds on 6/19/15.
//  Copyright (c) 2015 potato. All rights reserved.
//

#import "ActiveRecordBase.h"
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
@interface Cacher : NSObject
-(instancetype) initWithKey:(NSString *)key;
-(NSData *)get;
-(void)write:(NSData *)data;
@end
