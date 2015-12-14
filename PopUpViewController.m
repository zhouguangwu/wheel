//
//  PopUpViewController.m
//  ad
//
//  Created by webuser on 15/12/8.
//  Copyright © 2015年 fish. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>{
    UITableView *_table;
    NSArray *_data;
}

@end

@implementation PopUpViewController
-(instancetype)initWithData:(NSArray *)data{
    if (self = [super init]) {
        NSParameterAssert(data.count > 0);
        _data = data;
        _rowHeight = 44;
        _width = 100;
        _color = [UIColor whiteColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.7;
    [self.view addSubview:mask];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [mask addGestureRecognizer:tap];
    CGPoint p3[3];
    CGFloat w = 20;
    make3Points(p3, CGPointMake(_point.x+_width/2-w/2, _point.y+w*sin(60*M_PI/180)), w, MakePointsDirectionTop);
    CAShapeLayer *l = makePolygon(p3, 3);
    l.fillColor = _color.CGColor;
    l.strokeColor = _color.CGColor;
    [self.view.layer addSublayer:l];
    _table = [[UITableView alloc] init];
    _table.delegate  =self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    CGFloat tableHeight = _data.count * _rowHeight;
    if (tableHeight+_point.y > kScreenHeight) {
        tableHeight = kScreenHeight-_point.y;
    }else{
        _table.scrollEnabled = NO;
    }
    _table.frame = CGRectMake(_point.x, _point.y + w*sin(60.0/180*M_PI), _width, tableHeight);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selected(self,indexPath.row);
}
-(void)close{
    [Utils runOnUiThread:^{
            NSLog(@"close");
        [self dismissViewControllerAnimated:NO completion:^{
            NSLog(@"closeed");
        }];
    }];
}

- (void)showAnimated:(BOOL)animated{
    //此时table还是nil
    [Utils runOnUiThread:^{
        if (kWindow.rootViewController.presentedViewController) {
            NSLog(@"show");
            [kWindow.rootViewController.presentedViewController presentViewController:self animated:animated completion:^{
                    NSLog(@"showed");
                }];
        }else{
            NSLog(@"show");
            [kWindow.rootViewController presentViewController:self animated:animated completion:^{
                    NSLog(@"showed");
                }];
        }
    }];
}

//-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
//    UIPresentationController *pc = [[UIPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
//    return pc;
//}

-(nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    BOOL uped = NO;
    if (!uped) {
        [_table up:_table.height/2];
        _table.transform = CGAffineTransformMakeScale(1, 0);
        _table.layer.anchorPoint = CGPointMake(0.5, 0);
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [[transitionContext containerView] addSubview:self.view];
        _table.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:finished];
    }];
}
showDealloc
@end
