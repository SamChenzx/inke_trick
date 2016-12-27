//
//  SamLiveHandler.m
//  inke
//
//  Created by Sam on 12/7/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLiveHandler.h"
#import "HttpTool.h"
#import "SamLive.h"
#import "SamLocationManager.h"
#import "SamAdvertise.h"

@implementation SamLiveHandler


+(void) executeGetHotLiveTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed
{
    [HttpTool getWithPath:API_HOT_LIVE params:nil success:^(id json) {
        if ([json[@"dm_error"]integerValue]) {
            failed(json[@"error_msg"]);
        } else {
            // get correct data
            NSArray *lives = [SamLive mj_objectArrayWithKeyValuesArray:json[@"lives"]];
            success(lives);
        }
    } failure:^(NSError *error) {
        
        failed(error);
        
    }];
}

+(void) executeGetNearbyLiveTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed
{
    SamLocationManager *manager = [SamLocationManager sharedManager];
    NSDictionary *params = @{@"uid":@"313054160",@"latitude":manager.latitude,@"longitude":manager.longitude};
    
    [HttpTool getWithPath:API_NEARBY_LIVE params:params success:^(id json) {
        if ([json[@"dm_error"]integerValue]) {
            failed(json[@"error_msg"]);
        } else {
            // get correct data
            NSArray *lives = [SamLive mj_objectArrayWithKeyValuesArray:json[@"lives"]];
            success(lives);
        }    } failure:^(NSError *error) {
       
        failed(error);
    }];
}

+(void) executeGetAdvertiseTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed
{
    [HttpTool getWithPath:API_NEARBY_LIVE params:nil success:^(id json) {
        if ([json[@"dm_error"]integerValue]) {
            failed(json[@"error_msg"]);
        } else {
            // get correct data
            SamAdvertise *advertise = [SamAdvertise mj_objectWithKeyValues:json[@"resoutces"][0]];
            success(advertise);
        }    } failure:^(NSError *error) {
            
            failed(error);
        }];
}

@end
