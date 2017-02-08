
//
//  FJBaseTableViewController.m
//  LTNavigationBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "UITabBar+Gradient.h"
#import "FJBaseTableViewController.h"
#import "UINavigationBar+Gradient.h"

@interface FJBaseTableViewController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat _originalOffsetY; //上一次偏移量
}
@end



@implementation FJBaseTableViewController

// 标签栏 高度
const CGFloat kStatusBarHeight = 49.0f;
const CGFloat kCustomTabBarHeight = 86.0f;
// 导航栏 高度
const CGFloat kNavigationBarHeight = 64.0f;
// 动画   默认 时间
const CGFloat kDefaultAnimationTime = 0.3f;

#pragma mark --- life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加 tableView
    [self.view addSubview:self.tableView];
    
}

- (void)setUpNavigationBar
{
    
}

#pragma mark --- private method

// 显示navigationBar 和 tabbar
- (void)showNavigationBarAndStatusBar {
    [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
    [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
}

//隐藏navigationBar 和 tabbar
- (void)hideNavigationBarAndStatusBar {
    [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
    [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
}

//恢复或隐藏navigationBar和statusBar
- (void)restoreNavigationBarAndStatusBarWithContentOffset:(CGPoint)contentOffset {
    CGFloat navigationBarCenterHeight  = kNavigationBarHeight/2.0;
    CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
    if (transformTy < 0 && transformTy > -kNavigationBarHeight) {
        if (transformTy < -navigationBarCenterHeight && contentOffset.y > -navigationBarCenterHeight) {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self hideNavigationBarAndStatusBar];
            }];
            
        }else {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self showNavigationBarAndStatusBar];
            }];
        }
    }
}

// 通过偏移量移动NavigationBar和StatusBar
- (void)moveNavigationBarAndStatusBarByOffsetY:(CGFloat)offsetY {
    CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
    CGFloat tabbarTransformTy = self.tabBarController.tabBar.transform.ty;
//    NSLog(@"transformTy: %lf---tabbarTransformTy: %lf",transformTy,tabbarTransformTy);
    
    // offset 向上滚动
    if (offsetY > 0) {
        if (fabs(transformTy) >= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty大于NavigationBar高度，导航栏离开可视范围，设置NavigationBar隐藏
            [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
        } else {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏在可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        }
        
        if (fabs(tabbarTransformTy) >= kStatusBarHeight) {
            //当StatusTabBar的transfrom.ty大于StatusTabBar高度，导航栏离开可视范围，设置StatusTabBar隐藏
            [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
        } else {
            //当当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏在可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        }
        // offset 向下滚动
    } else if(offsetY < 0){
        if (transformTy < 0 && fabs(transformTy) <= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏进入可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        } else {
            //当NavigationBar的transfrom.ty超过NavigationBar原来位置，设置NavigationBar显示
            [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
        }
        
        if (tabbarTransformTy <= kCustomTabBarHeight && tabbarTransformTy > 0) {
            //当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏进入可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        } else {
            //当StatusTabBar的transfrom.ty超过StatusTabBar原来位置，设置StatusTabBar显示
            [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
        }
    }
    
}

// 根据传入的类型和渐变程度,改变StatusBar的颜色和位置
- (void)setStatusBarTransformProgress:(CGFloat)progress statusBarStatusType:(StatusBarStatusType)statusBarStatusType{
    CGFloat transfromTy = self.tabBarController.tabBar.transform.ty;
    if (statusBarStatusType == StatusBarStatusTypeOfHidden) {
        if (transfromTy <= kCustomTabBarHeight) {
            [self.tabBarController.tabBar fj_moveByTranslationY:kCustomTabBarHeight * progress];
//            [self.tabBarController.tabBar fj_setImageViewAlpha:progress];
        }
    }else if(statusBarStatusType == StatusBarStatusTypeOfNormal) {
        [self.tabBarController.tabBar fj_setTranslationY:-progress];
//        CGFloat alpha = 1 - fabs(self.tabBarController.tabBar.transform.ty)/kStatusBarHeight;
//        [self.tabBarController.tabBar fj_setImageViewAlpha:alpha];
    }else if(statusBarStatusType == StatusBarStatusTypeOfShow) {
        if (transfromTy != 0) {
            [self.tabBarController.tabBar fj_moveByTranslationY: -kStatusBarHeight * progress];
//            [self.tabBarController.tabBar fj_setImageViewAlpha:(1-progress)];
        }
    }
}

// 根据传入的类型和渐变程度,改变NavigationBar的颜色和位置
- (void)setNavigationBarTransformProgress:(CGFloat)progress navigationBarStatusType:(NavigationBarStatusType)navigationBarStatusType{
    CGFloat transfromTy = self.navigationController.navigationBar.transform.ty;
    if (navigationBarStatusType == NavigationBarStatusOfTypeHidden) {
        if(transfromTy != -kNavigationBarHeight){
            [self.navigationController.navigationBar fj_moveByTranslationY:-kNavigationBarHeight * progress];
//            [self.navigationController.navigationBar fj_setImageViewAlpha:progress];
            if (self.tableView.bounds.origin.y < 0) {
                self.tableView.transform = CGAffineTransformMakeTranslation(0, -fabs(self.tableView.bounds.origin.y));
                self.tableView.frame = CGRectMake(0, -kNavigationBarHeight -fabs(self.tableView.bounds.origin.y), kScreenWidth, kScreenHeight + kNavigationBarHeight);
            }
            if (self.tableView.frame.origin.y < -kNavigationBarHeight) {
                self.tableView.frame = CGRectMake(0, -kNavigationBarHeight -fabs(self.tableView.bounds.origin.y), kScreenWidth, kScreenHeight + kNavigationBarHeight);
            }
        }
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeNormal) {
        [self.navigationController.navigationBar fj_setTranslationY: - progress];
//        CGFloat alpha = 1 - fabs(self.navigationController.navigationBar.transform.ty)/kNavigationBarHeight;
//        [self.navigationController.navigationBar fj_setImageViewAlpha:alpha];
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeShow) {
        if(transfromTy != 0){
            [self.navigationController.navigationBar fj_moveByTranslationY:-kNavigationBarHeight * progress];
            if (self.tableView.frame.origin.y < -kNavigationBarHeight) {
//                self.tableView.transform = CGAffineTransformMakeTranslation(0, -fabs(self.tableView.frame.origin.y)+kNavigationBarHeight);
                self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight + kNavigationBarHeight);
            }
//            [self.navigationController.navigationBar fj_setImageViewAlpha:(1-progress)];
        }
    }
}

#pragma mark --- custom delegate

/***************************************** UITableViewDelegate 和 UITableViewDataSource *****************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PlainTableViewControllerIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/***************************************** UIScrollViewDelegate *****************************************/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
    if (scrollView.contentOffset.y > - kNavigationBarHeight  && bottomOffset > 0 ) {
        CGFloat offsetY = scrollView.contentOffset.y - _originalOffsetY;
        [self moveNavigationBarAndStatusBarByOffsetY:offsetY];
    }
    _originalOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self restoreNavigationBarAndStatusBarWithContentOffset:scrollView.contentOffset];
}

#pragma mark --- getter method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
@end
