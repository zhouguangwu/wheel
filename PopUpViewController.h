//
//  PopUpViewController.h
//  ad
//
//  Created by webuser on 15/12/8.
//  Copyright © 2015年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController{
    @public
    void (^selected)(PopUpViewController*,UInt8);
}
-(instancetype)initWithData:(NSArray *)data;
@property CGPoint point;
@property CGFloat width,rowHeight;
@property UIColor *color;
-(void)showAnimated:(BOOL)animated;
-(void)close;
@end
