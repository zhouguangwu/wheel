//
//  SelectViewController.m
//  manage
//
//  Created by wayos-ios on 12/24/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController (){
    NSArray *_items;
    void (^_block)(int);
    NSString *_title;
}

@end

@implementation SelectViewController

- (instancetype) initWithTitle:(NSString *)title items:(NSArray *)items{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _title = title;
        _items = items;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customBackBarButtonItem];
    self.navigationItem.title  = _title;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(_cancel)];
}

-(void)_cancel{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setResult:(void (^)(int))block{
    _block = block;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _items[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _block((int)indexPath.row);
}

-(UINavigationController *)nav{
    if (self.navigationController) {
        return self.navigationController;
    }else{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
        [nav.navigationBar commonSetting];
        return  nav;
    }
}

-(void)dealloc{
    NSLog(@"%@ dealloc",self.class);
}
@end
