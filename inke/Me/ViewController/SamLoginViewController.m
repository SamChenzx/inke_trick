//
//  SamLoginViewController.m
//  inke
//
//  Created by Sam on 12/20/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"
#import "SamUserHelper.h"
#import "SamTabBarViewController.h"


@interface SamLoginViewController ()

@end

@implementation SamLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sinaLogin:(id)sender {
    
    [self getAuthWithUserInfoFromSina];
}

- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Login error: %@",error.userInfo.description);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
//            // 授权信息
//            NSLog(@"Sina uid: %@", resp.uid);
//            NSLog(@"Sina accessToken: %@", resp.accessToken);
//            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
//            NSLog(@"Sina expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Sina name: %@", resp.name);
//            NSLog(@"Sina iconurl: %@", resp.iconurl);
//            NSLog(@"Sina gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            [SamUserHelper sharedUser].nickName = resp.name;
            [SamUserHelper sharedUser].iconURL = resp.iconurl;
            [SamUserHelper saveUser];
            self.view.window.rootViewController = [[SamTabBarViewController alloc]init];
        }
    }];
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
