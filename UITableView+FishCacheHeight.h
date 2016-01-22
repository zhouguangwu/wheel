//
//  UITableView+CacheHeight.h
//  ad
//
//  Created by webuser on 16/1/13.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FishCacheHeight)
-(void)go_fish_CacheHeight;
-(NSCache *)fish_cache;
-(NSString *)fish_cacheKeyFromPath:(NSIndexPath *)indexPath;
-(CGFloat)fish_heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)fish_reloadData;
-(void)fish_insertRowsAtIndexPaths:(NSArray *)paths;
-(void)fish_reloadRowsAtIndexPaths:(NSArray *)paths;
@end
