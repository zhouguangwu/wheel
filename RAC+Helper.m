//
//  RAC+Helper.m
//  fang
//
//  Created by webuser on 16/3/14.
//  Copyright © 2016年 webuser. All rights reserved.
//

#import "RAC+Helper.h"
#import "ReactiveCocoa.h"

@implementation NSArray (rac)
-(void)rac_attachBtn:(UIButton *)btn and:(BOOL (^)(void))block{
    NSMutableArray *sigs = [NSMutableArray array];
    for (UITextField *f in self) {
        [sigs addObject:f.rac_textSignal];
    }
    RAC(btn,enabled) = [RACSignal combineLatest:sigs reduce:^(){
        BOOL has0 = [[self valueForKey:@"text"] containsObject:@""];
        return @(!has0 && block());
    }];
}
@end
