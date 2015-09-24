//
//  Factory.h
//  eat
//
//  Created by wayos-ios on 9/29/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//  new

#import <UIKit/UIKit.h>
#import "BlockButton.h"
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
