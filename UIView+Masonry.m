//
//  UIView+Masony.m
//  ad
//
//  Created by St.Pons Mr.G on 15/11/18.
//  Copyright © 2015年 fish. All rights reserved.
//

#import "UIView+Masonry.h"
#import "Masonry.h"

@implementation UIView (Masony)
-(void)mas_right:(UIView *)left width:(id)width height:(id)height offset:(CGFloat)offset{
    [self mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.equalTo(left.mas_right).offset(offset);
        maker.top.equalTo(left.mas_top);
        if (width) {
            maker.width.equalTo(width);
        }
        if (height) {
            maker.height.equalTo(height);
        }
    }];
}
-(void)mas_css:(UIView *)css width:(id)width height:(id)height offset:(CGFloat)offset{
    [self mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.equalTo(css.mas_left);
        maker.top.equalTo(css.mas_bottom).offset(offset);
        if (width) {
            maker.width.equalTo(width);
        }
        if (height) {
            maker.height.equalTo(height);
        }
    }];
}
-(void)mas_center:(UIView *)center width:(id)width height:(id)height offset:(CGFloat)offset{
    [self mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.center.equalTo(center).centerOffset(CGPointMake(0, offset));
        maker.width.equalTo(width);
        maker.height.equalTo(height);
    }];
}
-(void)mas_right_bottom:(UIView *)bottom width:(id)width height:(id)height{
    [self mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.width.equalTo(width);
        maker.height.equalTo(height);
        maker.right.equalTo(bottom.mas_right);
        maker.bottom.equalTo(@0);
    }];
}
@end

@implementation MASConstraintMaker (mas)

-(void)leftTop{
    self.left.equalTo(@0);
    self.top.equalTo(@0);
}

-(void)leftTopRight{
    [self leftTop];
    self.right.equalTo(@0);
}
-(void)leftTopBottom{
    [self leftTop];
    self.bottom.equalTo(@0);
}
@end
@implementation UITableView (mas)

-(void)mas_go{
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 44;
}

@end