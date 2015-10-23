//
//  Utils.m
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "Utils.h"
@implementation Utils
+ (void) runBackGroud:(void (^)(void))block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        block();
    });
}

+ (void) runBackGroudOnSerialQueue:(void (^)(void))block{
    static dispatch_queue_t serialQ = nil;
    if (serialQ == nil) {
        serialQ = dispatch_queue_create("fish.serial", NULL);
    }
    dispatch_async(serialQ,^{
        block();
    });
}

+ (void) runOnUiThread:(void (^)(void))block{
    //sd源码
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void) write:(NSString *)value key:(NSString *)key{
    NSLog(@"\n写入%@:%@\n",key,value);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSString *) get:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];
}

+ (NSString *) itoS:(int)n{
    return itoS(n);
}

+ (NSNumber *) itoN:(int)i{
    return itoN(i);
}

+ (NSString *) objToJsonStr:(id) obj{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id) jsonStrToObj:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error:nil];
}

+ (void) assert:(BOOL)ok desc:(NSString *)desc{
    if (!ok) {
        NSAssert(NO, desc);
    }
}

+ (UINavigationController *)rootNav{
    return (UINavigationController *)kWindow.rootViewController;
}

- (void)dealloc{
    NSLog(@"utils dealloc");
}

@end

NSString *itoS(int n){
    return [NSString stringWithFormat:@"%d",n];
}

NSNumber *itoN(int n){
    return [NSNumber numberWithInt:n];
}
UINavigationController * rootNav(){
    return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

#include <execinfo.h>
void exceptionHandler(NSException *exception){
    NSString * const exceptionKey = @"exception";
    NSMutableString *finalStr = [NSMutableString stringWithFormat:@"%@,%@,%@",exception,exception.callStackSymbols,exception.callStackReturnAddresses];
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    for (int i=0;i<frames;i++){
        [finalStr appendFormat:@"%s\n",strs[i]];
    }
    free(strs);
    [Utils write:finalStr key:exceptionKey];
}

CAShapeLayer* makePolygon(CGPoint *points,UInt8 count){
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    for (UInt8 i = 0; i < count; i++) {
        if (i == 0) {
            [progressline moveToPoint:points[i]];
        }else{
            [progressline addLineToPoint:points[i]];
        }
    }
//    [progressline stroke];
    chartLine.path = progressline.CGPath;
    return chartLine;
}