//
//  UITableView+Mj.h
//  ad
//
//  Created by webuser on 11/26/15.
//  Copyright © 2015 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MjDelegate
-(void)refresh;
-(void)nextWithPage:(UInt8)page;
@end
@interface UITableView (Mj)
@property(readonly) UInt8 page;
@property UIView *noDataView;
-(void)goMjWithBeginPage:(UInt8)page delegate:(id <MjDelegate>)delegate;
-(void)endRefresh;
-(void)endRefreshWithNoData;
-(void)endRefreshWithNoFooter;
-(void)endNext;
-(void)endNextWithNoMoreData;
-(void)showNoDataView;
@end
