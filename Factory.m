//
//  Factory.m
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "Factory.h"
#import "Category.h"
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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
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
        NSString *thisStr = texts[i];
        if (![thisStr hasSuffix:@"\n"]) {
            thisStr = thisStr.addN;
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:thisStr attributes:attributes];
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