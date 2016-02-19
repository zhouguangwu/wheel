//
//  MBProgressHUD+wheel.h
//  fish
//
//  Created by webuser on 2/19/16.
//  Copyright © 2016 webuser. All rights reserved.
//

#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "AFHTTPRequestOperation.h"
void toast(NSString *str);
void toastWithTime(NSString *str,NSTimeInterval t);
@interface MBProgressHUD (wheel)
@property AFHTTPRequestOperation *operation;
@end
@interface UIView (hub)
- (void) toast:(NSString *)str time:(NSTimeInterval)t;
@end
