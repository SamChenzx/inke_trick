//
//  SamContributionViewController.m
//  inke
//
//  Created by Sam on 12/23/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamContributionViewController.h"
#import "SamTestView.h"

@interface SamContributionViewController ()

@end

@implementation SamContributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SamTestView *test = [SamTestView loadView];
    test.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
