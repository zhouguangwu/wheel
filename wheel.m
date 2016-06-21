
#import "wheel.h"
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
@implementation KeyValue
@end
@implementation UIView (Helper)

- (UIImage *) renderImage{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) up:(int)offset{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y - offset, frame.size.width, frame.size.height);
}

- (void) down:(int)offset{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y+offset, frame.size.width, frame.size.height);
}


- (void) down:(int)dis completion:(void (^)(void))block{
    CGPoint center = self.center;
    center.y = center.y + dis;
    [UIView animateWithDuration:0.2 animations:^{
        self.center = center;
    } completion:^(BOOL finished){
        if (block != nil) {
            block();
        }
    }];
}

- (void) right:(int)offset{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x+offset, frame.origin.y, frame.size.width, frame.size.height);
}

- (void) left:(int)offset{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x - offset, frame.origin.y, frame.size.width, frame.size.height);
}

- (void) addHeight:(int)hei{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + hei);
}

- (void) subHeight:(int)hei{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - hei);
}

- (void) border{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWith256R:218 G:218 B:218] CGColor];
}

- (void) border:(UIColor *)color{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [color CGColor];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >  __IPHONE_8_4
- (CAShapeLayer *)makeDashBorder:(UIColor *)color pattern:(NSArray<NSNumber *> *)patterns{
#else
- (CAShapeLayer *)makeDashBorder:(UIColor *)color pattern:(NSArray *)patterns{
#endif
    return makeDashBorder(self.bounds, color, patterns);
}

- (void) removeAllSubViews{
    NSArray *subViews = self.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
}

- (void) addWidth:(int)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + width, self.frame.size.height);
}

- (void) round{
    self.layer.masksToBounds = YES;
    if (self.constraints.count == 0) {
        self.layer.cornerRadius = self.frame.size.width/2;
    }else{//autolayout问题
        self.layer.cornerRadius = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width/2;
    }
}

- (void) round:(CGFloat)radius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (UIView *)frstResponder{
    for (UIView *subView in self.subviews) {
        if (subView.isFirstResponder) {
            return subView;
        }
    }
    return nil;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)hideKeybord{
    [[self frstResponder] resignFirstResponder];
}
-(void)removeAllGestures{
    NSArray *gess = self.gestureRecognizers;
    for (UIGestureRecognizer *ges in gess) {
        [self removeGestureRecognizer:ges];
    }
}
@end

@implementation UIViewController(Helper)
- (void) quickAlertWithTitle:(NSString *)title message:(NSString *)message{
    if (title == nil) {
        title = @"提示";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)quickAlert:(NSString *)message{
    UIAlertController *c = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *root = kWindow.rootViewController;
    __weak typeof(root) weakRoot = root;
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){
        [weakRoot dismissViewControllerAnimated:YES completion:nil];
    }];
    [c addAction:a];
    [root presentViewController:c animated:YES completion:^{}];
}

-(UIAlertController *)confirmWithTitle:(NSString *)title message:(NSString *)message ok:(void (^)(UIAlertController *))block{
    UIAlertController *c = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *a){
    }];
    __weak typeof(c) weakC  =c;
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){
        block(weakC);
    }];
    [c addAction:a1];
    [c addAction:a2];
    [self presentViewController:c animated:YES completion:nil];
    return c;
}
    
-(UIAlertController *)promtWithTitle:(NSString *)title ok:(void (^)(UITextField *))block{
    UIAlertController *c = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *a){
    }];
    __block UITextField *field;
    [c addTextFieldWithConfigurationHandler:^(UITextField *f){
        field = f;
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){
        block(field);
    }];
    [c addAction:a1];
    [c addAction:a2];
    [self presentViewController:c animated:YES completion:^{
        [field becomeFirstResponder];
    }];
    return c;
}

- (void) debug{
    UIImageView *debugView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    debugView.image = [UIImage imageNamed:@"d.jpg"];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:debugView atIndex:0];
}

- (void) cusBackItemWithTitle:(NSString *)title{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.backBarButtonItem = item;
}

- (void) cusLeftItemWithTitle:(NSString *)title{
    title = title.length > 0 ? title : @"返回" ;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, title.length * 20, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void) customLeftBarButtonItem{
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(5, 5, 10, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void) customBackBarButtonItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
}

@end

@implementation UITextField(Helper)

- (void) changeLeftViewImageNameed:(NSString *)name{
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    leftView.frame = CGRectMake(10, 0, 25, 15);
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void) paddingLeft:(CGFloat) padding{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, padding)];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end

@implementation UINavigationController (Helper)
- (void) changeTopViewController:(UIViewController *)vc animated:(BOOL)animated{
    NSParameterAssert([vc isKindOfClass:UIViewController.class]);
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.viewControllers];
    vcs[vcs.count-1] = vc;
    [self setViewControllers:vcs animated:animated];
}
@end

@implementation UINavigationItem (Helper)
- (void) changeWhiteTitle:(NSString *)title{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 100, 20) text:title color:[UIColor whiteColor] fontSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.titleView = label;
}

@end

@implementation UILabel (Helper)
- (void) flex{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.text.length * 15, self.frame.size.height);
}
@end

@implementation UIImage (Helper)

-(NSString *) base64String{
    NSString *str = [UIImageJPEGRepresentation(self, 1.0) base64EncodedStringWithOptions:0];
    return str;
}

- (UIImage *)cut{
    if (self.size.width < [UIScreen mainScreen].bounds.size.width) {
        return self;
    }else{
        CGSize newSize = [UIScreen mainScreen].bounds.size;
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *oriData = UIImagePNGRepresentation(self);
        NSData *newData = UIImagePNGRepresentation(newImage);
        NSLog(@"裁剪图片size %f,%f\n length=%d,%d",self.size.width,newImage.size.width,(int)oriData.length,(int)newData.length);
        return newImage;
    }
}

-(UIImage *)compress:(UInt16)k{
    UIImage *finalImage = self;
    NSData *beforeData = UIImageJPEGRepresentation(self, 1.0);
    if (beforeData.length > k * 1024) {//大于阀值
        CGFloat delta = (k*1024) / beforeData.length;
        finalImage = [UIImage imageWithData: UIImageJPEGRepresentation(self, delta)];
        NSLog(@"压缩前%d,压缩后%d,系数%f",(int)beforeData.length,(int)UIImageJPEGRepresentation(finalImage, 1.0).length,(float)delta);
    }
    return finalImage;
}
-(UIImage *)compress2:(CGFloat)maxW{
    if (self.size.width < maxW) {
        return self;
    }else{
        CGFloat maxY = maxW*self.size.height/self.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(maxW, maxY));
        [self drawInRect:CGRectMake(0, 0, maxW, maxY)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
#ifdef DEBUG
        NSLog(@"压缩前%d,size=%d,%d,压缩后%d,%d,%d",(int)UIImageJPEGRepresentation(self, 1).length,(int)self.size.width,(int)self.size.height,(int)UIImageJPEGRepresentation(newImage, 1).length,(int)newImage.size.width,(int)newImage.size.height);
#endif
        return newImage;
    }
}
@end
@implementation NSArray (Helper)
- (NSArray *)pluck:(NSString *)name{
    return [self valueForKey:name];
}
- (NSArray *)group:(NSString *)name{
    NSMutableArray *results = [NSMutableArray array];
    //逻辑分离
    NSArray *keys = [self pluck:name];
    keys = [[NSSet setWithArray:keys] allObjects];
    for (NSString *key in keys) {
        KeyValue *kv = [[KeyValue alloc] init];
        kv.key = key;
        kv.value = [self filter:^(id obj){
            id value = [obj valueForKey:name];
            if (value == key) {
                return YES;
            }else{
                return NO;
            }
        }];
        [results addObject:kv];
    }
    
    return results;
}

- (NSArray *)kPluck:(NSString *)name{
    return [self valueForKey:name];
}

-(NSArray *) reverse{
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    NSMutableArray *newDatas = [NSMutableArray array];
    id data ;
    while (data = [enumerator nextObject]) {
        [newDatas addObject:data];
    }
    return newDatas;
}

- (NSArray *) filter:(BOOL (^)(id))condition{
    NSMutableArray *newDatas = [NSMutableArray array];
    for (id one in self) {
        if (condition(one)) {
            [newDatas addObject:one];
        }
    }
    return newDatas;
}

- (id) objOfClass:(Class)klass{
    id resultObj;
    for (NSObject *o in self) {
        if ([o isMemberOfClass:klass]) {
            resultObj = o;
        }
    }
    
    return resultObj;
}
-(NSArray *)add:(NSString *)sufix{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        [result addObject:[NSString stringWithFormat:@"%@%@",obj,sufix]];
    }
    return result;
}
-(NSRange)rangeOf:(NSArray *)arr{
    NSParameterAssert(arr.count > 0);
    NSParameterAssert(self.count >= arr.count);
    return NSMakeRange([self indexOfObject:arr.firstObject], arr.count);
}
    
-(NSArray *)arrayByCount:(UInt8)c{
    NSMutableArray *result = [NSMutableArray array];
    if (self.count > 0) {
        UInt8 line = (self.count -1)/c + 1;
        for (UInt8 i = 0; i < line; i++) {
            if (self.count < i*c+c) {
                [result addObject:[self subarrayWithRange:NSMakeRange(i*c, self.count-i*c)]];
            }else{
                [result addObject:[self subarrayWithRange:NSMakeRange(i*c, c)]];
            }
        }
    }
    return result;
}
@end

@implementation UITableViewCell (Helper)

- (void) commonSetting{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

@implementation NSString  (Helper)

-(NSDate *) toDate{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.locale = NSLocale.currentLocale;
    if (self.length == 10) {
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if(self.length == 16){
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate* inputDate = [inputFormatter dateFromString:self];
    return inputDate.toLocal;
}

- (NSString *)base64Encode{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}
- (NSString *)base64Decode{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
-(NSString *)addN{
    return [NSString stringWithFormat:@"%@\n",self];
}
-(NSString *)toHtml{
    return [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head><body>%@</body></html>",self];
}
@end

@implementation UITableView (Helper)

- (void) emptyFooter{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    self.tableFooterView = footerView;
}

- (void) emptyHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    self.tableHeaderView = headerView;
}
@end
@implementation NSDate (Helper)
- (NSDate *)toLocal{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    return localeDate;
}
- (UInt8) day{
    return [[self.description substringWithRange:NSMakeRange(8, 2)] intValue];
}
- (UInt8) hour{
    return [[self.description substringWithRange:NSMakeRange(11, 2)] intValue];
}
- (UInt8) minute{
    return [[self.description substringWithRange:NSMakeRange(14, 2)] intValue];
}
- (UInt8) second{
    return [[self.description substringWithRange:NSMakeRange(17, 2)] intValue];
}
@end

@implementation NSMutableArray (Helper)
- (void) deleteIf:(BOOL (^)(id))block{
    NSMutableArray *tobeDeletes = [NSMutableArray array];
    for (id obj in self) {
        if (block(obj)) {
            [tobeDeletes addObject:obj];
        }
    }
    for (id obj in tobeDeletes) {
        [self removeObject:obj];
    }
}
@end

@implementation NSTimer (Helper)

- (void) pause{
    self.fireDate = NSDate.distantFuture;
}

- (void) resume{
    self.fireDate = [NSDate date];
}

@end

@implementation NSData (Helper)

-(id) jsonObj{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableLeaves  error:&error];
//    NSAssert1(error == nil, @"json解析出错%@",error);
    return obj;
}
@end

@implementation UIButton (Helper)
#define kUIButtonClickedBlockSelector @selector(_buttonClickedBlock)
- (void)_clicked{
    ButtonClieckedBlock block = [self _buttonClickedBlock];
    block();
}

- (ButtonClieckedBlock)_buttonClickedBlock{
    return  objc_getAssociatedObject(self, kUIButtonClickedBlockSelector);
}

- (void)setClicked:(ButtonClieckedBlock)block{
    objc_setAssociatedObject(self, kUIButtonClickedBlockSelector, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(_clicked) forControlEvents:UIControlEventTouchUpInside];
}
@end
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
@implementation NSObject (Helper)
-(NSArray *)propertyNames{
    unsigned int count = 0;
    objc_property_t *properties= class_copyPropertyList([self class], &count);
    NSMutableArray *propertys = [NSMutableArray array];
    for (int i = 0; i < count ; OSAtomicIncrement32(&i)){
        const char* propertyName = property_getName(properties[i]);
        NSString *strName = [NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertys addObject:strName];
    }
    return propertys;
}
-(NSString *)className{
    return NSStringFromClass(self.class);
}
@end

@implementation AVAudioPlayer (Helper)
+(void)play:(NSString *)path repeat:(BOOL)is{
    NSError *err;
    static AVAudioPlayer *player;//这个对象不能死得额
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    if (is) {
        player.numberOfLoops = -1;
    }
    NSAssert(player, err.description);
    [player play];
}
@end
CGRect scaleRectMake(float scaleX, float scaleY, float scaleWidth, float scaleHeight){
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat x = scaleX <= 1. ? scaleX * size.width : scaleX;
    CGFloat y = scaleY <= 1 ? scaleY * size.height : scaleY ;
    CGFloat width = scaleWidth <= 1. ? scaleWidth * size.width : scaleWidth;;
    CGFloat height = scaleHeight <= 1 ? scaleHeight * size.height : scaleHeight;
    
    return CGRectMake(x, y, width, height);
}

@implementation UIButton(Factory)
+ (instancetype) buttonWithFrame:(CGRect)frame title:(NSString *)title{
    UIButton * button = CGRectIsEmpty(frame) ? [UIButton new] : [[self.class alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    UIButton *button = [self.class buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

+(UIButton *) bigButtonWithFrame:(CGRect) frame imageName:(NSString *)imageName{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(frame.origin.x - width*0.35, frame.origin.y - height*0.35, width*1.7, height * 1.7);

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * 0.35, height*0.35, width, height)];
    imageView.image = [UIImage imageNamed:imageName];
    [button addSubview:imageView];
    return button;
}
@end

@implementation UILabel (Factory)
+ (instancetype) labelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color fontSize:(CGFloat)size{
    UILabel *label = CGRectIsEmpty(frame) ? UILabel.new : [[UILabel alloc]  initWithFrame:frame];
    label.text  =text;
    label.textColor = color == nil ?  [UIColor blackColor] : color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+ (instancetype) labelWithFrame:(CGRect) frame texts:(NSArray *) texts attr:(NSDictionary *) attr attrs:(NSArray *)attrs{
    NSAssert(texts.count == attrs.count, @"字的个数和attrs的个数不一样");
    UILabel *label = CGRectIsEmpty(frame) ? UILabel.new : [[UILabel alloc]  initWithFrame:frame];
    label.attributedText = [NSAttributedString stringWithTexts:texts attr:attr attrs:attrs];
    label.numberOfLines = 0;
    return label;
}
@end


@implementation UITextField (Factory)
+ (UITextField *) filedWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = placeHolder;
    return field;
}
@end

@implementation UIBarButtonItem (Factory)
+(UIBarButtonItem *) imageItemWithName:(NSString *)name target:(id)target action:(SEL)action{
    return [self imageItemWithName:name frame:CGRectMake(5, 5, 30, 20) target:target action:action];
}

+ (UIBarButtonItem *) imageItemWithName:(NSString *)name frame:(CGRect)frame target:(id)target action:(SEL)action{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [self itemWithTitle:title frame:CGRectMake(0, 0, 40, 30) target:target action:action];
}
    
+(UIBarButtonItem *)itemWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
@end

@implementation UINavigationController(Factory)
+(UINavigationController *) tabbarNavigationControllerWithRootViewController:(UIViewController *)controller barTitle:(NSString *)title barImageName:(NSString *)imageName{
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    navVC.tabBarItem.title = title;
    return navVC;
}
@end

@implementation UIColor (Factory)
+ (UIColor *) colorWith256R:(int)r G:(int)g B:(int)b{
    return [UIColor colorWithRed:((float)r)/255 green:((float)g)/255 blue:((float)b)/255 alpha:1];
}
@end

@implementation UIView (Factory)
-(CGRect) cssFrameWithWidth:(int)width height:(int)height{
    if (height < 1) {
        height = [UIScreen mainScreen].bounds.size.height * height;
    }
    return CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, width, height);
}

- (CGRect) cssFrameWithWidth:(int) width height:(int) height offset:(int) offset{
    if (height < 1) {
        height = [UIScreen mainScreen].bounds.size.height * height;
    }
    return CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height + offset, width, height);
}

- (CGRect) rightFrameWithWidth:(int) width height:(int) height{
    return [self rightFrameWithWidth:width height:height offset:0];
}

- (CGRect) rightFrameWithWidth:(int) width height:(int) height offset:(int)offset{
    return CGRectMake(self.frame.origin.x + self.frame.size.width + offset,self.frame.origin.y, width, height);
}

- (CGRect) rightBottomFrameWithWidth:(int) width height:(int) height{
    return CGRectMake(self.bounds.size.width - width, self.bounds.size.height-height, width, height);
}

- (CGRect) leftTopFrameWithWidth:(int) width height:(int) height{
    return CGRectMake(0, 0, width, height);
}

- (CGRect) centerFrameWithWidth:(CGFloat) width height:(CGFloat) height{
    return [self centerFrameWithWidth:width height:height deltaY:0];
}

- (CGRect) centerFrameWithWidth:(CGFloat) width height:(CGFloat) height deltaY:(CGFloat) deltaY{
    int fullWidth = self.bounds.size.width,fullHeight = self.bounds.size.height;
    return CGRectMake((fullWidth - width)/2, (fullHeight - height)/2 + deltaY, width, height);
}
@end

@implementation UITextView (Factory)
+(instancetype) contentTextViewWithFrame:(CGRect)frame content:(NSString *)content{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.text = content;
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    return textView;
}
@end

@implementation NSAttributedString (Factory)

+ (instancetype) stringWithTexts:(NSArray *) texts attr:(NSDictionary *) attr attrs:(NSArray *)attrs{
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0 ; i < texts.count; i++) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:attr];
        NSAssert([attrs[i] isKindOfClass:NSDictionary.class], @"%d不是字典",i);
        NSAssert([texts[i] isKindOfClass:NSString.class], @"%d不是string",i);
        [attributes addEntriesFromDictionary:attrs[i]];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:texts[i] attributes:attributes];
        [totalStr appendAttributedString:str];
    }
    return totalStr;
}

@end

@implementation UIFont (Factory)

+ (instancetype) blodFontWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    return font;
}

@end

@implementation NSArray (Factory)
-(NSArray *)create:(Class)klass{
    NSMutableArray *works = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self) {
        id one = [klass performSelector:@selector(create:) withObject:info];
        [works addObject:one];
    }
    
    return works;
}

@end

@implementation NSString (Factory)
+(instancetype) stringWithJsonObj:(id)obj{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
    NSAssert(err == nil, @"json转码错误");
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(id) jsonObj{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] jsonObj];
}
@end

@implementation NSIndexPath (Factory)

+(NSArray *)indexPathsForRows:(NSRange)range inSection:(NSInteger)section{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < range.length; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:range.location + i inSection:section];
        [indexPaths addObject:path];
    }
    return indexPaths;
}

@end

@implementation UIImage (Factory)

+(instancetype)imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end