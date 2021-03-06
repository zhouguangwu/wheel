//
//  UIView+Masony.h
//  ad
//
//  Created by St.Pons Mr.G on 15/11/18.
//  Copyright © 2015年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masony)
-(void)mas_right:(UIView *)left width:(id)width height:(id)height offset:(CGFloat)offset;
-(void)mas_css:(UIView *)css width:(id)width height:(id)height offset:(CGFloat)offset;
-(void)mas_center:(UIView *)center width:(id)width height:(id)height offset:(CGFloat)offset;
-(void)mas_right_bottom:(UIView *)bottom width:(id)width height:(id)height;
@end
@interface MASConstraintMaker (mas)
-(void)leftTop;
-(void)leftTopRight;
-(void)leftTopBottom;
@end
@interface UITableView (mas)
-(void)mas_go;
@end