//
//  Category.m
//  eat
//
//  Created by wayos-ios on 9/30/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "Category.h"
#import "Factory.h"
#import "Utils.h"
#import <objc/runtime.h>
@implementation KeyValue
@end
@implementation UIView (Helper)
- (void) toast:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:kToastTime];
}

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

- (CAShapeLayer *)makeDashBorder:(UIColor *)color pattern:(NSArray<NSNumber *> *)patterns{
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
    self.layer.cornerRadius = self.frame.size.width/2;
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
@end

@implementation UIViewController(Helper)
- (void) quickAlertWithTitle:(NSString *)title message:(NSString *)message{
    if (title == nil) {
        title = @"提示";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
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
    if (UIImagePNGRepresentation(self).length > k * 1024) {//大于阀值
        CGFloat delta = (k*1024) / UIImageJPEGRepresentation(self,1.0).length;
        finalImage = [UIImage imageWithData: UIImageJPEGRepresentation(self, delta)];
    }
    NSLog(@"压缩前%d,压缩后%d",(int)UIImageJPEGRepresentation(self, 1.0).length,(int)UIImageJPEGRepresentation(finalImage, 1.0).length);
    return finalImage;
}
@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
@implementation NSArray (Helper)
- (NSArray *)pluck:(NSString *)name{
    NSMutableArray *results = [NSMutableArray array];
    for (id obj in self) {
        SEL sel = NSSelectorFromString(name);
        [results addObject:[obj performSelector:sel]];
    }
    return results;
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
            SEL sel = NSSelectorFromString(name);
            id value = [obj performSelector:sel];
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
#pragma clang diagnostic pop

- (NSArray *)kPluck:(NSString *)name{
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *dic in self) {
        assert([dic isKindOfClass:NSDictionary.class]);
        [results addObject:dic[name]];
    }
    return results;
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
