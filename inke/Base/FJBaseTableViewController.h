//
//  FJBaseTableViewController.h
//  LTNavigationBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SamBaseViewController.h"

@interface FJBaseTableViewController : SamBaseViewController
// tableView
@property (nonatomic, strong) UITableView *tableView;
// 设置 导航栏
- (void)setUpNavigationBar;
@end
