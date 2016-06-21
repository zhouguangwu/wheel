//
//  UITableView+Mj.m
//  ad
//
//  Created by webuser on 11/26/15.
//  Copyright © 2015 fish. All rights reserved.
//

#import "UITableView+Mj.h"
#import "MJRefresh.h"

const void *MjTableDelegateKey = &MjTableDelegateKey;
const void *MjTablePageKey = &MjTablePageKey;
const void *MjTableBeginPageKey = &MjTableBeginPageKey;
const void *MjTableNodataViewKey = &MjTableNodataViewKey;
@implementation UITableView (Mj)
-(void)setMjDelegate:(id<MjDelegate>)mjDelegate{
    objc_setAssociatedObject(self, MjTableDelegateKey, mjDelegate, OBJC_ASSOCIATION_ASSIGN);
}
-(id<MjDelegate>)mjDelegate{
    return objc_getAssociatedObject(self, &MjTableDelegateKey);
}
-(void)setPage:(UInt8)page{
    objc_setAssociatedObject(self, MjTablePageKey, @(page), OBJC_ASSOCIATION_ASSIGN);
}
-(UInt8)page{
    NSNumber *page = objc_getAssociatedObject(self, &MjTablePageKey);
    return page.intValue;
}

-(UInt8)beginPage{
    NSNumber *page = objc_getAssociatedObject(self, &MjTableBeginPageKey);
    return page.intValue;
}
-(void)goMjWithBeginPage:(UInt8)page delegate:(id<MjDelegate>)delegate{
    [self setMjDelegate:delegate];
    NSAssert(self.mjDelegate, @"请设置mjdelegate");
    self.page = page;
    objc_setAssociatedObject(self, MjTableBeginPageKey, @(page), OBJC_ASSOCIATION_ASSIGN);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refresh)];
    [self.mj_header beginRefreshing];
}
-(void)endRefresh{
    [self.mj_header endRefreshing];
    self.page = [self beginPage];
    NSLog(@"结束刷新%d",self.page);
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_next)];
    self.mj_footer.automaticallyHidden = NO;
}
-(void)endRefreshWithNoFooter{
    [self.mj_header endRefreshing];
    self.page = [self beginPage];
}
//如果刷新没成功， footer出不来， 所以footer不必考虑nodata问题
-(void)endRefreshWithNoData{
    [self.mj_header endRefreshing];
    self.page = [self beginPage];
    [self showNoDataView];
}
-(void)endNext{
    [self.mj_footer endRefreshing];
    self.page++;
}
-(void)endNextWithNoMoreData{
    self.page++;
    [self.mj_footer endRefreshingWithNoMoreData];
}
-(void)_next{
    if (self.mj_header.isRefreshing) {
        toast(@"正在刷新, 请稍后再分页");
        [self.mj_footer endRefreshing];
        return;
    }
    NSLog(@"下一页%d",self.page);
    [self.mjDelegate nextWithPage:self.page+1];
}
-(void)_refresh{
    if (self.mj_footer && self.mj_footer.isRefreshing) {
        toast(@"正在分页, 请稍后再刷新");
        [self.mj_header endRefreshing];
        return;
    }
    [self.noDataView removeFromSuperview];
    self.mj_footer = nil;
    [self.mjDelegate refresh];
}

-(void)setNoDataView:(UIView *)noDataView{
    objc_setAssociatedObject(self, MjTableNodataViewKey, noDataView, OBJC_ASSOCIATION_RETAIN);
}
-(UIView *)noDataView{
   return objc_getAssociatedObject(self, &MjTableNodataViewKey);
}
-(void)showNoDataView{
    self.mj_footer = nil;
    NSParameterAssert(self.noDataView);
    [self addSubview:self.noDataView];
}
@end
