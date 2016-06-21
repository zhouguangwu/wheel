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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >  __IPHONE_8_4
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray<NSNumber *>* patterns);
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray<NSNumber *>* patterns);
#else
CAShapeLayer * makeDashBorder(CGRect frame,UIColor * color,NSArray* patterns);
CAShapeLayer *makeDashLine(CGPoint *points,UInt8 length,NSArray* patterns);
#endif
CAShapeLayer *makeLine(CGPoint *points,UInt8 length);
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

#define showDealloc \
-(void)dealloc{\
NSLog(@"%@ dealloc",self.class);\
}
#define ViewControllerHideKeybordWhenTap \
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(hideKeybord)];\
[self.view addGestureRecognizer:tap];
//和nsdicitonar不同, 只有一个key,一个v
@interface KeyValue : NSObject
@property(retain) id key,value;
@end
@interface UIView (Helper)
- (UIImage *) renderImage;
- (void) up:(int) offset;
- (void) down:(int) offset;
- (void) down:(int)dis completion:(void (^)(void))block;
- (void) right:(int) offset;
- (void) left:(int) offset;
- (void) addHeight: (int) hei;
- (void) subHeight: (int) hei;
- (void) border;
- (void) border:(UIColor *)color;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >  __IPHONE_8_4
- (CAShapeLayer *) makeDashBorder:(UIColor *)color pattern:(NSArray<NSNumber *>*) patterns;
#else
- (CAShapeLayer *) makeDashBorder:(UIColor *)color pattern:(NSArray*) patterns;
#endif
- (void) removeAllSubViews;
- (void) addWidth:(int) width;
- (void) round;
- (void) round:(CGFloat)radius;
- (UIView *)frstResponder;
-(CGFloat)width;
-(CGFloat)height;
-(void)hideKeybord;
-(void)removeAllGestures;
@end

@interface UIViewController (Helper)
- (void) quickAlertWithTitle:(NSString *) title message:(NSString *) message;
-(void)quickAlert:(NSString *)message;
-(UIAlertController *)confirmWithTitle:(NSString *) title message:(NSString *) message ok:(void (^)(UIAlertController *))block;
- (UIAlertController *)promtWithTitle:(NSString *)title ok:(void (^)(UITextField *))block;
- (void) debug;
- (void) cusBackItemWithTitle:(NSString *)title;
- (void) cusLeftItemWithTitle:(NSString *)title;
- (void) customLeftBarButtonItem;
- (void) customBackBarButtonItem;
@end

@interface UITextField (Helper)
- (void) changeLeftViewImageNameed: (NSString *) name;
- (void) paddingLeft:(CGFloat) padding;
@end

@interface UINavigationController (Helper)
- (void) changeTopViewController:(UIViewController *)vc animated:(BOOL)animated;
@end

@interface UINavigationItem (Helper)
- (void) changeWhiteTitle:(NSString *)title;
@end

@interface UILabel (Helper)
- (void) flex;
@end

@interface UIImage (Helper)
- (NSString *) base64String;
- (UIImage *)cut;
- (UIImage *)compress:(UInt16)k;
- (UIImage *)compress2:(CGFloat)maxW;
@end

@interface NSArray (Helper)
-(NSArray *) pluck:(NSString *)name;
-(NSArray *) group:(NSString *)name;
-(NSArray *) kPluck:(NSString *)name;
-(NSArray *) reverse;
//filter不会copy对象, 只会吧符合条件的对象搞到一个新数组里面去
-(NSArray *) filter:(BOOL (^)(id))condition;
-(id) objOfClass:(Class) klass;
-(NSArray *)add:(NSString *)sufix;
-(NSRange)rangeOf:(NSArray *)arr;
-(NSArray *)arrayByCount:(UInt8)c;
@end

@interface UITableViewCell (Helper)
- (void) commonSetting;
@end

@interface NSString  (Helper)
- (NSDate *) toDate;
- (NSString *)base64Encode;
- (NSString *)base64Decode;
-(NSString *)addN;
-(NSString *)toHtml;
@end
@interface UITableView (Helper)
- (void) emptyFooter;
- (void) emptyHeader;
@end

@interface NSDate (Helper)
- (NSDate *)toLocal;
- (UInt8) hour;
- (UInt8) day;
- (UInt8) minute;
- (UInt8) second;
@end

@interface NSMutableArray (Helper)
- (void) deleteIf:(BOOL(^)(id))block;
@end

@interface NSTimer (Helper)
- (void) pause;
- (void) resume;
@end

@interface NSData (Helper)
- (id) jsonObj;
@end
typedef void (^ButtonClieckedBlock)(void);
@interface UIButton (Helper)
- (void) setClicked:(ButtonClieckedBlock) block;
@end

@interface NSObject(Helper)
-(NSArray *)propertyNames;
-(NSString *)className;
@end

#import <AVFoundation/AVFoundation.h>
@interface AVAudioPlayer (Helper)
+(void)play:(NSString *)path repeat:(BOOL)is;
@end
CGRect scaleRectMake(float scaleX, float scaleY, float scaleWidth, float scaleHeight);

@interface UIButton(Factory)
+(instancetype) buttonWithFrame:(CGRect) frame title:(NSString *)title;
+(instancetype) buttonWithFrame:(CGRect) frame imageName:(NSString *)imageName;
+(UIButton *) bigButtonWithFrame:(CGRect) frame imageName:(NSString *)imageName;
@end

@interface UILabel (Factory)
+ (instancetype) labelWithFrame:(CGRect) frame text:(NSString *) text color:(UIColor *)color fontSize:(CGFloat) size;
+ (instancetype) labelWithFrame:(CGRect) frame texts:(NSArray *) texts attr:(NSDictionary *) attr attrs:(NSArray *)attrs;
@end

@interface UITextField (Factory)
+ (UITextField *)filedWithFrame:(CGRect) frame placeHolder:(NSString *)placeHolder;
@end

@interface UIBarButtonItem (Factory)
+ (UIBarButtonItem *) imageItemWithName:(NSString *)name target:(id)target action:(SEL)action;
+ (UIBarButtonItem *) imageItemWithName:(NSString *)name frame:(CGRect)frame target:(id)target action:(SEL)action;
+ (UIBarButtonItem *) itemWithTitle: (NSString *)title target:(id) target action:(SEL) action;
@end

@interface UINavigationController (Factory)
+ (UINavigationController *)tabbarNavigationControllerWithRootViewController:(UIViewController *)controller
                                                                    barTitle:(NSString *)title
                                                                barImageName:(NSString *)imageName;
@end

@interface UIColor (Factory)
+ (UIColor *) colorWith256R:(int)r G:(int)g B:(int)b;
@end

@interface UIView (Factory)
- (CGRect) cssFrameWithWidth:(int) width height:(int) height;
- (CGRect) cssFrameWithWidth:(int) width height:(int) height offset:(int) offset;
- (CGRect) rightFrameWithWidth:(int) width height:(int) height;
- (CGRect) rightFrameWithWidth:(int) width height:(int) height offset:(int) offset;
- (CGRect) rightBottomFrameWithWidth:(int) width height:(int) height;
- (CGRect) leftTopFrameWithWidth:(int) width height:(int) height;
- (CGRect) centerFrameWithWidth:(CGFloat) width height:(CGFloat) height;
- (CGRect) centerFrameWithWidth:(CGFloat) width height:(CGFloat) height deltaY:(CGFloat) deltaY;
@end

@interface UITextView (Factory)
+(instancetype) contentTextViewWithFrame:(CGRect)frame content:(NSString *)content;
@end

@interface NSAttributedString (Factory)
+ (instancetype) stringWithTexts:(NSArray *) texts attr:(NSDictionary *) attr attrs:(NSArray *)attrs;
@end

@interface UIFont (Factory)
+ (instancetype) blodFontWithSize:(CGFloat)fontSize;
@end

@interface NSArray (Factory)
-(NSArray *)create:(Class)klass;
@end

@interface NSString (Factory)
+(instancetype) stringWithJsonObj:(id)obj;
-(id) jsonObj;
@end

@interface NSIndexPath (Factory)
+(NSArray *)indexPathsForRows:(NSRange)range inSection:(NSInteger)section;
@end
@interface UIImage (Factory)
+(instancetype)imageWithColor:(UIColor *)color;
@end