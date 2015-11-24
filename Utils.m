//
//  Utils.m
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "Utils.h"
BOOL validateEmpty(NSArray *fields,NSArray *infos){
    assert(fields.count == infos.count && fields.count > 0);
    for (UITextField *field in fields) {
        if (field.text.length == 0) {
            [rootNav() quickAlertWithTitle:infos[[fields indexOfObject:field]] message:@""];
            return NO;
        }
    }
    return YES;
}
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

+ (UINavigationController *)tabRootNav{
    return  (UINavigationController *)[(UITabBarController *)kWindow.rootViewController selectedViewController];
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
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray<NSNumber *>* patterns){
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.lineDashPattern = patterns;
    border.path =  [UIBezierPath bezierPathWithRect:frame].CGPath;
    border.fillColor = [UIColor clearColor].CGColor;
    return border;
}

CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray<NSNumber *>* patterns){
    assert(patterns.count > 0);
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor blackColor].CGColor;
    border.lineDashPattern = patterns;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:*points];
    for (UInt8 i = 1; i < length; i++) {
        [path addLineToPoint:points[i]];
        [path moveToPoint:points[i]];
    }
    border.path = path.CGPath;
    return border;
}

void toast(NSString *str){
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-40)/2, kScreenWidth, 40)];
    [kWindow addSubview:toastView];
    [toastView toast:str];
    [toastView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kToastTime+0.1];
}

void make3Points(CGPoint *points,CGPoint origin,CGFloat w,MakePointsDirection direction){
    CGPoint ps[3] = {origin,CGPointMake(w/2/sin(45)+origin.x, origin.y+w/2/sin(45)),CGPointMake(w+origin.x, origin.y)};
    memcpy(points, ps, sizeof(CGPoint)*3);
}