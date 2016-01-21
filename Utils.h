//
//  Utils.h
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define todayComponents [[NSCalendar currentCalendar] components:NSUIntegerMax fromDate:NSDate.date]
//afn
#define isNetworkOk [AFNetworkReachabilityManager sharedManager].reachable
#define check_network if (!isNetworkOk) {\
toast(@"请连接网络");\
return;\
}
#define check_network_and_return(a) if (!isNetworkOk) {\
toast(@"请连接网络");\
return a;\
}

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
#define kRootTab (UITabBarController *)kWindow.rootViewController
#define goWeakSelf kWeakSelf(weakSelf);
#define kWeakSelf(w)  __weak typeof(self) w = self
#define kStrong(w,s) __strong typeof(w) s = w
#define kStrongSelfFromWeak(w) kStrong(w,self)
#define goStrongSelf kStrongSelfFromWeak(weakSelf);
#define kIsShort kScreenHeight < 500
#define IOS9_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )
#define namedImage(a) [UIImage imageNamed:a]
#define DECLARE_SINGLETON_FOR_CLASS(classname) \
+ (classname*)shared##classname;
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
#define kHubTag 999
#define showHub() MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:kWindow animated:YES];hub.tag=kHubTag;
#define hideHub() [MBProgressHUD hideHUDForView:kWindow animated:YES]
#define kToastTime 1
#define FontAttribute(s) NSFontAttributeName:[UIFont systemFontOfSize:s]
#define ColorAttributeWhite ColorAttribute([UIColor whiteColor])
#define ColorAttribute(c) NSForegroundColorAttributeName:c
#define BaiduMobStatLogViewController(viewController) \
    static NSString *previousViewControllerName = nil;\
    if (previousViewControllerName) {\
        [[BaiduMobStat defaultStat] pageviewEndWithName:previousViewControllerName];\
    }\
    [[BaiduMobStat defaultStat] pageviewStartWithName:viewController.className];\
    previousViewControllerName = viewController.className;
BOOL validateEmpty(NSArray *fields,NSArray *infos);
@interface Utils : NSObject
+ (void) runBackGroud:(void (^)(void))block;
+ (void) runBackGroudOnSerialQueue:(void (^)(void))block;
+ (void) runOnUiThread:(void (^)(void))block;
+ (void) write:(NSString *)value key:(NSString *)key;
+ (NSString *) get:(NSString *)key;
+ (NSString *) itoS:(NSInteger) n;
+ (NSNumber *)itoN:(int) i;
+ (NSString *) objToJsonStr:(id) obj;
+ (id) jsonStrToObj:(NSString *)str;
+ (void) assert:(BOOL) ok desc:(NSString *)desc;
+ (UINavigationController *)rootNav;
@end
NSString *itoS(NSInteger n);
NSNumber *itoN(int n);
UINavigationController * rootNav();
void exceptionHandler(NSException *exception);
CAShapeLayer* makePolygon(CGPoint *points,UInt8 count);
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray<NSNumber *>* patterns);
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray<NSNumber *>* patterns);
CAShapeLayer *makeLine(CGPoint *points,UInt8 length);
#ifdef MB_INSTANCETYPE
void toast(NSString *str);
void toastWithTime(NSString *str,NSTimeInterval t);
#endif
typedef enum{
    MakePointsDirectionTop,
    MakePointsDirectionLeft,
    MakePointsDirectionBottom,
    MakePointsDirectionRight
} MakePointsDirection;
void make3Points(CGPoint *points,CGPoint origin,CGFloat width,MakePointsDirection direction);
UINavigationController * tabRootNav();
BOOL isIdCard(NSString *idCard);
void redirectLogToFile();