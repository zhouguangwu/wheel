//
//  RAC+Helper.h
//  fang
//
//  Created by webuser on 16/3/14.
//  Copyright © 2016年 webuser. All rights reserved.
//



@interface NSArray (rac)
-(void)rac_attachBtn:(UIButton *)btn and:(BOOL (^)(void))block;
@end
