//
//  MJExtensionConfig.m
//  inke
//
//  Created by Sam on 12/7/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "SamCreator.h"
#import "SamLive.h"

@implementation MJExtensionConfig

+(void) load
{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
    
    [SamCreator mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"desc" : @"description"
                 };
    }];
    
    //Camel to underline
    [SamCreator mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
        return [propertyName mj_underlineFromCamel];
    }];
    
    [SamLive mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
        return [propertyName mj_underlineFromCamel];
    }];
}

@end
