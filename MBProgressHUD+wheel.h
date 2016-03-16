//
//  MBProgressHUD+wheel.h
//  fish
//
//  Created by webuser on 2/19/16.
//  Copyright © 2016 webuser. All rights reserved.
//

#import "MBProgressHUD.h"
#import <objc/runtime.h>
#define showhub(h,title) MBProgressHUD *h = [[MBProgressHUD alloc] initWithView:kWindow];\
h.labelText = title; \
[kWindow addSubview:h]; \
[h show:YES];\
h.removeFromSuperViewOnHide = YES;
#define kHubTag 999
#define showHub() MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:kWindow animated:YES];hub.tag=kHubTag;
#define hideHub() [MBProgressHUD hideHUDForView:kWindow animated:YES]
void toast(NSString *str);
void toastWithTime(NSString *str,NSTimeInterval t);
@interface MBProgressHUD (wheel)
#if AFNetworkingVersion == 3
@property NSURLSessionDownloadTask *operation;
#else
@property AFHTTPRequestOperation *operation;
#endif
@end
@interface UIView (hub)
- (void) toast:(NSString *)str time:(NSTimeInterval)t;
@end
