//
//  Cacher.m
//  waimai
//
//  Created by birds on 6/19/15.
//  Copyright (c) 2015 potato. All rights reserved.
//

#import "Cacher.h"

@implementation Cacher{
    NSString *_key;
}
-(instancetype) initWithKey:(NSString *)key{
    if (self = [super init]) {
        _key = key;
    }
    return self;
}

- (NSString *)path{
    NSString *path = kCachePath;
    return [path stringByAppendingPathComponent:_key];
}

-(NSData *)get{
    return [NSData dataWithContentsOfFile:self.path];
}

- (void)write:(NSData *)data{
    
}
@end
