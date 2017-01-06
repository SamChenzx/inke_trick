//
//  SamTabBarViewController.m
//  inke
//
//  Created by Sam on 11/29/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTabBarViewController.h"
#import "SamTabBar.h"
#import "SamBaseNavViewController.h"
#import "SamLaunchViewController.h"

@interface SamTabBarViewController () <SamTabBarDelegate>

@property(nonatomic, strong) SamTabBar* samTabBar;

@end

@implementation SamTabBarViewController

-(SamTabBar *)samTabBar
{
    if (!_samTabBar) {
        _samTabBar = [[SamTabBar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
//        _samTabBar = [[SamTabBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];

        _samTabBar.delegate = self;
    }
    return _samTabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // add controller
    [self configViewControllers];
    // add tabbar
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    self.tabBar.hidden = YES;
    [self.view addSubview:self.samTabBar];
//    self.tabBar.userInteractionEnabled = YES;
//    [self.tabBar addSubview:self.samTabBar];
//    self.tabBar.clipsToBounds = NO;
}



-(void)viewWillLayoutSubviews
{

}

-(void)configViewControllers
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"SamMainViewController",@"SamMeTableViewController"]];
    for (NSInteger i = 0; i<array.count; i++) {
        NSString *vcName = array[i];
        UIViewController *vc = [[NSClassFromString(vcName) alloc]init];
        SamBaseNavViewController *nav = [[SamBaseNavViewController alloc]initWithRootViewController:vc];
        [array replaceObjectAtIndex:i withObject:nav];
    }
    self.viewControllers = array;
}

-(void)tabBar:(SamTabBar *)tabBar clickButton:(SamItemType)index
{
    if (index != SamItemTypeLaunch) {
        //当前tabbar的索引
        self.selectedIndex = index - SamItemTypeLive;
        
    } else if(index == SamItemTypeLaunch) {
        [self launchLive];
    }
    
}

-(void) launchLive
{
    SamLaunchViewController *launchVC = [[SamLaunchViewController alloc]init];
    [self presentViewController:launchVC animated:YES completion:nil];
    NSLog(@"Launch Live");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
