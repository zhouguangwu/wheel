//
//  QrcodeViewController.h
//  qx
//
//  Created by wayos-ios on 12/2/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QrcodeViewController : UIViewController
- (instancetype) initWithSucBlock:(void (^)(NSString *))sucBlock;
@end
