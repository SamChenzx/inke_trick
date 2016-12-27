//
//  AppDelegate+SamUmeng.m
//  inke
//
//  Created by Sam on 12/21/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "AppDelegate+SamUmeng.h"
#import "UMSocialSinaHandler.h"
#import <UMSocialCore/UMSocialCore.h>


@implementation AppDelegate (SamUmeng)

- (void)setupUMeng
{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"585a31b7e88bad7be600178e"];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1333654703"  appSecret:@"cc12f5e985417c8905a7f501a2b769fd" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}


@end
