//
//  SamCacheHelper.m
//  inke
//
//  Created by Sam on 12/16/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamCacheHelper.h"

#define adImage @"advertiseImage"

@implementation SamCacheHelper

+ (NSString *)getAdvertise
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:adImage];
}

+ (void)setAdvertise:(NSString *)advertiseImage
{
    
    [[NSUserDefaults standardUserDefaults] setObject:advertiseImage forKey:@"advertiseImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
