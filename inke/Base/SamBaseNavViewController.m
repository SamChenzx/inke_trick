//
//  SamBaseNavViewController.m
//  inke
//
//  Created by Sam on 11/30/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamBaseNavViewController.h"

@interface SamBaseNavViewController ()

@end

@implementation SamBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0 green:216 blue:201 alpha:1];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
