//
//  MBProgressHUD+wheel.m
//  fish
//
//  Created by webuser on 2/19/16.
//  Copyright © 2016 webuser. All rights reserved.
//

#import "MBProgressHUD+wheel.h"
#import "Utils.h"
#define kToastTime 1
void toast(NSString *str){
    toastWithTime(str, kToastTime+0.1);
}
void toastWithTime(NSString *str,NSTimeInterval t){
    const NSInteger tag = 444;
    if ([kWindow viewWithTag:tag]) {
        [[kWindow viewWithTag:tag] removeFromSuperview];
    }
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-40)/2, kScreenWidth, 40)];
    toastView.tag = tag;
    [kWindow addSubview:toastView];
    [toastView toast:str time:t];
    //hub是自动hide的,但是背景必须手动
    [toastView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
}
const void *MBProgressHUDOperationKey = &MBProgressHUDOperationKey;
@implementation MBProgressHUD (wheel)
-(void)setOperation:(AFHTTPRequestOperation *)operation{
    objc_setAssociatedObject(self, MBProgressHUDOperationKey, operation, OBJC_ASSOCIATION_RETAIN);
}
-(AFHTTPRequestOperation *)operation{
    return objc_getAssociatedObject(self, MBProgressHUDOperationKey);
}
@end
@implementation UIView (hub)
- (void) toast:(NSString *)str time:(NSTimeInterval)t{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:t];
}
@end
