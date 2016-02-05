//
//  Utils.m
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "Utils.h"
#import "Category.h"
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

+ (NSString *) itoS:(NSInteger)n{
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


@end

NSString *itoS(NSInteger n){
    return [NSString stringWithFormat:@"%d",(int)n];
}

NSNumber *itoN(int n){
    return [NSNumber numberWithInt:n];
}
UINavigationController * rootNav(){
    return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

#include <execinfo.h>
#import "Category.h"
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
    CAShapeLayer *border = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:*points];
    for (UInt8 i = 1; i < count; i++) {
        [path addLineToPoint:points[i]];
    }
//    [progressline stroke];
    border.path = path.CGPath;
    return border;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >  __IPHONE_8_4
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray<NSNumber *>* patterns){
#else
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray* patterns){
#endif
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.lineDashPattern = patterns;
    border.path =  [UIBezierPath bezierPathWithRect:frame].CGPath;
    border.fillColor = [UIColor clearColor].CGColor;
    return border;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >  __IPHONE_8_4
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray<NSNumber *>* patterns){
#else
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray* patterns){
#endif
    assert(patterns.count > 0);
    CAShapeLayer *border = [CAShapeLayer layer];
    border.lineDashPattern = patterns;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:*points];
    for (UInt8 i = 1; i < length; i++) {
        [path addLineToPoint:points[i]];
        [path moveToPoint:points[i]];//每次move一下, 让他无法形成包围圈
    }
    border.path = path.CGPath;
    return border;
}

CAShapeLayer *makeLine(CGPoint *points,UInt8 length){
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor blackColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:*points];
    for (UInt8 i = 1; i < length; i++) {
        [path addLineToPoint:points[i]];
        [path moveToPoint:points[i]];
    }
    border.path = path.CGPath;
    return border;
}

#ifdef MB_INSTANCETYPE
void toast(NSString *str){
    toastWithTime(str, kToastTime+0.1);
}
void toastWithTime(NSString *str,NSTimeInterval t){
    const NSInteger tag = 444;
    if ([kWindow viewWithTag:tag]) {
        [[kWindow viewWithTag:tag] removeFromSuperview];
    }
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-40)/2, kScreenWidth, 40)];
    toastView.tag = tag;
    [kWindow addSubview:toastView];
    [toastView toast:str time:t];
    //hub是自动hide的,但是背景必须手动
    [toastView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
}
#endif
//w是边长, 先从左到右,再从上到下
void make3Points(CGPoint *points,CGPoint origin,CGFloat w,MakePointsDirection direction){
    CGFloat half = w*sin(60*M_PI/180);//中线的长度
    if (direction == MakePointsDirectionBottom) {
        CGPoint ps[3] = {origin,CGPointMake(w/2+origin.x, origin.y+half),CGPointMake(w+origin.x, origin.y)};
        memcpy(points, ps, sizeof(CGPoint)*3);
    }else if (direction == MakePointsDirectionLeft){
        CGPoint ps[3] = {origin,CGPointMake(half+origin.x, origin.y-w/2),CGPointMake(half+origin.x, origin.y+w/2)};
        memcpy(points, ps, sizeof(CGPoint)*3);
    }else if (direction == MakePointsDirectionTop){
        CGPoint ps[3] = {origin,CGPointMake(origin.x+w/2, origin.y-half),CGPointMake(origin.x+w, origin.y)};
        memcpy(points, ps, sizeof(CGPoint)*3);
    }
    else{
        assert(NO);
    }
}

UINavigationController * tabRootNav(){
    return  (UINavigationController *)[(UITabBarController *)kWindow.rootViewController selectedViewController];
}
BOOL isIdCard(NSString *idCard){
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}
void redirectLogToFile(){
    NSString *documentsDirectory = kDocumentsPath;
    NSString *fileName = @"ad.log";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}