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

@property(nonatomic, strong) UIButton *cameraButton;

@end

@implementation SamTabBarViewController

-(SamTabBar *)samTabBar
{
    if (!_samTabBar) {
        _samTabBar = [[SamTabBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        _samTabBar.delegate = self;
    }
    
    return _samTabBar;
}

- (UIButton *)cameraButton {
    
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(launchLive) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.tag = SamItemTypeLaunch;
    }
    return _cameraButton;
}

-(void) launchLive
{
    SamLaunchViewController *launchVC = [[SamLaunchViewController alloc]init];
    [self presentViewController:launchVC animated:YES completion:nil];
   
    NSLog(@"Launch Live");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // add controller
    [self configViewControllers];
    // add tabbar
    [self.tabBar addSubview:self.samTabBar];
    [self.view addSubview: self.cameraButton];
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

-(void)viewWillLayoutSubviews
{
    [self.cameraButton sizeToFit];
    self.cameraButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-self.cameraButton.bounds.size.height*0.6);
}


-(void)tabBar:(SamTabBar *)tabBar clickButton:(SamItemType)index
{
    NSLog(@"get in the tabbar delegate!!!");
    if (index != SamItemTypeLaunch) {
        //当前tabbar的索引
        self.selectedIndex = index - SamItemTypeLive;
        return;
    }
    
    SamLaunchViewController * launchVC = [[SamLaunchViewController alloc] init];
    
    [self presentViewController:launchVC animated:YES completion:nil];

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
