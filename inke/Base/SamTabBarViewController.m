//
//  SamTabBarViewController.m
//  inke
//
//  Created by Sam on 11/29/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTabBarViewController.h"
#import "SamBaseNavViewController.h"
#import "SamLaunchViewController.h"
#import "SamLaunchOptionView.h"

@interface SamTabBarViewController () <SamTabBarDelegate,SamLaunchOptionDelegate>

@property(nonatomic, strong) SamTabBar* samTabBar;
@property (nonatomic, strong) SamLaunchOptionView *launchOptionView;


@end

@implementation SamTabBarViewController

-(SamTabBar *)samTabBar
{
    if (!_samTabBar) {
        _samTabBar = [[SamTabBar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, kScreenWidth, 50)];
        _samTabBar.delegate = self;
    }
    return _samTabBar;
}

- (SamLaunchOptionView *)launchOptionView
{
    if (!_launchOptionView) {
        _launchOptionView = [[SamLaunchOptionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchOptionView.delegate = self;
    }
    return _launchOptionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // add controller
    [self configViewControllers];
    self.view.autoresizesSubviews = NO;
    // add tabbar
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [self setValue:self.samTabBar forKey:@"tabBar"];
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
        self.selectedIndex = index - SamItemTypeLive;
        
    } else if(index == SamItemTypeLaunch) {
        [self.launchOptionView showUp];
    }
    
}

- (void)launchOptionView:(SamLaunchOptionView *)launchOptionView clickButtonAtIndex:(SamLaunchType)index
{
    if (index == SamLaunchTypeCamera) {
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
