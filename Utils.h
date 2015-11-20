//
//  Utils.h
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define kDocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kBarHeight 44
#define Ios6 ([[UIDevice currentDevice].systemVersion floatValue] < 7)
#define LongScreen [UIScreen mainScreen].bounds.size.height > 500
#define CenterX(width) (kScreenWidth-width)/2
#define SmartyY(y) [UIScreen mainScreen].bounds.size.height * y / 568
#define smarty(x) x*kScreenWidth/320
#define kWindow [UIApplication sharedApplication].keyWindow
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define netOn [NetUtils currentNetWorkStatus] != NetworkStatusNotReachable
#define kRootNav [Utils rootNav]
#define kWeakSelf(w)  __weak typeof(self) w = self
#define kStrong(w,s) __strong typeof(w) s = w
#define kIsShort kScreenHeight < 500
#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )
#define namedImage(a) [UIImage imageNamed:a]
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
return shared##classname; \
}
#define showhub(h,title) MBProgressHUD *h = [[MBProgressHUD alloc] initWithView:kWindow];\
h.labelText = title; \
[kWindow addSubview:h]; \
[h show:YES];\
h.removeFromSuperViewOnHide = YES;
#define showHub() [MBProgressHUD showHUDAddedTo:kWindow animated:YES]
#define hideHub() [MBProgressHUD hideHUDForView:kWindow animated:YES]
#define kToastTime 1
BOOL validateEmpty(NSArray *fields,NSArray *infos);
void toast(NSString *str);
@interface Utils : NSObject
+ (void) runBackGroud:(void (^)(void))block;
+ (void) runBackGroudOnSerialQueue:(void (^)(void))block;
+ (void) runOnUiThread:(void (^)(void))block;
+ (void) write:(NSString *)value key:(NSString *)key;
+ (NSString *) get:(NSString *)key;
+ (NSString *) itoS:(int) n;
+ (NSNumber *)itoN:(int) i;
+ (NSString *) objToJsonStr:(id) obj;
+ (id) jsonStrToObj:(NSString *)str;
+ (void) assert:(BOOL) ok desc:(NSString *)desc;
+ (UINavigationController *)rootNav;
@end
NSString *itoS(int n);
NSNumber *itoN(int n);
UINavigationController * rootNav();
void exceptionHandler(NSException *exception);
CAShapeLayer* makePolygon(CGPoint *points,UInt8 count);
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray<NSNumber *>* patterns);
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray<NSNumber *>* patterns);