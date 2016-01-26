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
    NSParameterAssert(hs);
    return hs;
}

-(CGFloat)fish_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSCache *cache= [self fish_cache];
    id value = [cache objectForKey:indexPath.fish_CacheKey];
    if (value) {
        NSLog(@"缓存命中 ");
        return [value floatValue];
    }else{
        NSLog(@"没有缓存中");
        UITableViewCell *cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        value = [self fish_cache_cell:cell forIndexPath:indexPath];
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
        [[self fish_cache] removeObjectForKey:indexPath.fish_CacheKey];
    }
}
-(NSNumber *)fish_cache_cell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    NSCache *cache= [self fish_cache];
    id value = @([cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
    NSLog(@"存储高度%d,%@",(int)indexPath.row,value);
    [cache setObject:value forKey:indexPath.fish_CacheKey];
    return value;
}
@end
@implementation NSIndexPath (FishCacheHeight)
-(NSString *)fish_CacheKey{
    return [NSString stringWithFormat:@"%d_%d",(int)self.section,(int)self.row];
}
@end
