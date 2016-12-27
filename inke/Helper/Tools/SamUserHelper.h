//
//  SamUserHelper.h
//  inke
//
//  Created by Sam on 12/22/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SamUserHelper : NSObject

@property(nonatomic, copy) NSString * iconURL;
@property(nonatomic, copy) NSString * nickName;

+ (instancetype)sharedUser;
+ (BOOL)isAutoLogin;
+ (void)saveUser;


@end
