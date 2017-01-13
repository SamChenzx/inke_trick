//
//  SamLaunchViewController.m
//  inke
//
//  Created by Sam on 12/2/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLaunchViewController.h"
#import "LFLivePreview.h"

@interface SamLaunchViewController () 


@end

@implementation SamLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)closeLaunch:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)startLive:(id)sender {
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    LFLivePreview * preview = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    preview.vc = self;
    [self.view addSubview:preview];
    // start live
    [preview startLive];
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
