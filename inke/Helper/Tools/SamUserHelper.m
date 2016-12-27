//
//  SamUserHelper.m
//  inke
//
//  Created by Sam on 12/22/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamUserHelper.h"

@implementation SamUserHelper

+(instancetype) sharedUser
{
    static SamUserHelper *_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[SamUserHelper alloc] init];
    });
    return _user;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _iconURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconURL"];
        _nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    }
    return self;
}

+ (BOOL)isAutoLogin
{
    if ([SamUserHelper sharedUser].nickName.length == 0) {
        return NO;
    }
    return YES;
}

+ (void)saveUser
{
    SamUserHelper * user = [SamUserHelper sharedUser];
    if (user.nickName.length != 0) {
        [[NSUserDefaults standardUserDefaults] setObject:user.iconURL forKey:@"iconURL"];
        [[NSUserDefaults standardUserDefaults] setObject:user.nickName forKey:@"nickName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
