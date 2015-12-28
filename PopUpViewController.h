//
//  PopUpViewController.h
//  ad
//
//  Created by webuser on 15/12/8.
//  Copyright © 2015年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#define cellYInTableView(cell,tableView) cell.frame.origin.y-tableView.contentOffset.y + kBarHeight
@interface PopUpViewController : UIViewController{
    @public
    void (^selected)(PopUpViewController*,UInt8);
    void (^canceled)(PopUpViewController *);
}
-(instancetype)initWithData:(NSArray *)data;
@property CGPoint point;
@property CGFloat width,rowHeight;
@property UIColor *color;
-(void)showAnimated:(BOOL)animated;
-(void)close;
@end
