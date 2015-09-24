//
//  SelectViewController.h
//  manage
//
//  Created by wayos-ios on 12/24/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UITableViewController
- (instancetype) initWithTitle:(NSString *)title items:(NSArray *)items;
- (void) setResult:(void (^)(int i)) block;
- (UINavigationController *)nav;
@end
