//
//  Category.h
//  eat
//
//  Created by wayos-ios on 9/30/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>

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
- (void) removeAllSubViews;
- (void) addWidth:(int) width;
- (void) round;
- (void) round:(CGFloat)radius;
- (UIView *)frstResponder;
- (void) addLine:(CGFloat) y;
- (void) addPointLine:(CGRect) frame pointSize:(CGSize)size offset:(CGFloat)offset color:(UIColor *)color;
- (void) addLineWithFrame:(CGRect)frame;
-(CGFloat)width;
-(CGFloat)height;
@end

@interface UIViewController (Helper)
- (void) quickAlertWithTitle:(NSString *) title message:(NSString *) message;
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
@end

@interface NSArray (Helper)
-(NSArray *) pluck:(NSString *)name;
-(NSArray *) kPluck:(NSString *)name;
-(NSArray *) reverse;
//filter不会copy对象, 只会吧符合条件的对象搞到一个新数组里面去
-(NSArray *) filter:(BOOL (^)(id))condition;
-(id) objOfClass:(Class) klass;
@end

@interface UITableViewCell (Helper)
- (void) commonSetting;
@end

@interface NSString  (Helper)
- (NSDate *) toDate;
- (NSString *)base64Encode;
- (NSString *)base64Decode;
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
@end