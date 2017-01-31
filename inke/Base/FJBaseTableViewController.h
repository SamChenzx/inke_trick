//
//  FJBaseTableViewController.h
//  LTNavigationBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//


#import <UIKit/UIKit.h>

// 标签栏 高度
extern const CGFloat kStatusBarHeight;
// 导航栏 高度
extern const CGFloat kNavigationBarHeight;
// 动画   默认 时间
extern const CGFloat kDefaultAnimationTime;


@interface FJBaseTableViewController : UIViewController
// tableView
@property (nonatomic, strong) UITableView *tableView;
// 设置 导航栏
- (void)setUpNavigationBar;
@end
