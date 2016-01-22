//
//  UITableView+CacheHeight.m
//  ad
//
//  Created by webuser on 16/1/13.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UITableView+FishCacheHeight.h"
const void *CacheHeightKey = &CacheHeightKey;
@implementation UITableView (FishCacheHeight)
-(void)go_fish_CacheHeight{
    NSCache *cache = [[NSCache alloc] init];
    objc_setAssociatedObject(self, CacheHeightKey, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSCache *)fish_cache{
    NSCache *hs = objc_getAssociatedObject(self, &CacheHeightKey);
    return hs;
}
-(NSString *)fish_cacheKeyFromPath:(NSIndexPath *)indexPath{
    return [NSString stringWithFormat:@"%d_%d",(int)indexPath.section,(int)indexPath.row];
}

-(CGFloat)fish_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSCache *cache= [self fish_cache];
    id value = [cache objectForKey:[self fish_cacheKeyFromPath:indexPath]];
    if (value) {
        NSLog(@"缓存命中 ");
        return [value floatValue];
    }else{
        NSLog(@"没有缓存中");
        UITableViewCell *cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        value = @([cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
        [cache setObject:value forKey:[self fish_cacheKeyFromPath:indexPath]];
    }
    NSLog(@"计算出高度了  %d %d   %@",(int)indexPath.section,(int)indexPath.row,value);
    return [value floatValue];
}
-(void)fish_reloadData{
   //啥都不需要做,以后需要清楚缓存再说
}
-(void)fish_insertRowsAtIndexPaths:(NSArray *)paths{
   //啥都不需要做,以后需要默认值的时候再说
}
-(void)fish_reloadRowsAtIndexPaths:(NSArray *)paths{
    for (NSIndexPath *indexPath in paths) {
        [[self fish_cache] removeObjectForKey:[self fish_cacheKeyFromPath:indexPath]];
    }
}
@end
