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
        maker.width.equalTo(width);
        maker.height.equalTo(height);
    }];
}
@end
