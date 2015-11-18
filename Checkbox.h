//
//  Checkbox.h
//  jhq
//
//  Created by wayos-ios on 6/13/14.
//  Copyright (c) 2014 wayos. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Checkbox : UIButton
@property(nonatomic)  UIImage *checkedImage;
@property(nonatomic)  UIImage *unCheckedImage;
@property BOOL isChecked;
- (instancetype) initWithFrame:(CGRect)frame checkedImage:(UIImage *) checkedImage unckeckedImage:(UIImage *) unckeckedImage checked:(BOOL) isChecked;
- (instancetype) initWithCheckedImage:(UIImage *) checkedImage unckeckedImage:(UIImage *) unckeckedImage checked:(BOOL) isChecked;
- (void) toggle;//不会触发delegate
- (void) unCheck;
- (void) check;
- (void) click;
- (void) setCallback:(void (^)(Checkbox *))block;
@end
