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
#import "SamTickers.h"
#import "SamLocationManager.h"
#import "SamAdvertise.h"

@implementation SamLiveHandler


+(void) executeGetHotLiveTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed
{
    NSDictionary *params = @{@"lc":@"0000000000000045",@"cc":@"TG0001",@"cv":@"IK3.8.30_Iphone",@"proto":@"7",@"idfa":@"00000000-0000-0000-0000-000000000000",@"idfv":@"73A74722-B15B-48E1-8246-BBF344D3FA8C",@"devi":@"49ada13d88c4c6e87b0d5cc7c510fbb900bb2904",@"osversion":@"ios_10.100000",@"ua":@"iPhone7_2",@"imei":@"",@"imsi":@"",@"uid":@"313054160",@"sid":@"20AjNs0lbcb5EYvo45VIi2oWWvi1zc6hi2ui0nlXIa9C38RL8WwucB",@"conn":@"wifi",@"mtid":@"e7d80f17b447125143549330ee05cb30",@"mtxid":@"80e650124b1a",@"logid":@"133,5",@"id":@"1484370946508623,1484373765772108,1484372896008296,1484373662019674,1484373779344801",@"multiaddr":@"1",@"s_sg":@"a42e58ce0aa09fb4fa243da40ba305a8",@"s_sc":@"100",@"s_st":@"1484373631"};
    
//    /api/live/infos?lc=0000000000000045&cc=TG0001&cv=IK3.8.30_Iphone&proto=7&idfa=00000000-0000-0000-0000-000000000000&idfv=73A74722-B15B-48E1-8246-BBF344D3FA8C&devi=49ada13d88c4c6e87b0d5cc7c510fbb900bb2904&osversion=ios_10.100000&ua=iPhone7_2&imei=&imsi=&uid=313054160&sid=20AjNs0lbcb5EYvo45VIi2oWWvi1zc6hi2ui0nlXIa9C38RL8WwucB&conn=wifi&mtid=e7d80f17b447125143549330ee05cb30&mtxid=80e650124b1a&logid=133,5&id=1484370946508623%2C1484373765772108%2C1484372896008296%2C1484373662019674%2C1484373779344801&multiaddr=1&s_sg=a42e58ce0aa09fb4fa243da40ba305a8&s_sc=100&s_st=1484373631    
    [HttpTool getWithPath:API_HOT_LIVE params:params success:^(id json) {
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
        }
    } failure:^(NSError *error) {
       
        failed(error);
    }];
}

+ (void)executeGetTickersTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"lc":@"0000000000000043",@"cc":@"TG0001",@"cv":@"IK3.8.10_Iphone",@"proto":@"7",@"idfa":@"00000000-0000-0000-0000-000000000000",@"idfv":@"73A74722-B15B-48E1-8246-BBF344D3FA8C",@"devi":@"49ada13d88c4c6e87b0d5cc7c510fbb900bb2904",@"osversion":@"ios_10.100000",@"ua":@"iPhone7_2",@"imei":@"",@"imsi":@"",@"uid":@"313054160",@"sid":@"20gPQiPAyqHk3D22keDdi0Q2cAXeLtFWsAju4Rhm9cZ9TcKzi1Vfe",@"conn":@"wifi",@"mtid":@"e7d80f17b447125143549330ee05cb30",@"mtxid":@"80e650124b1a",@"logid":@"133,5",@"s_sg":@"1eea2e8d2d24f7377e6fbd182ee84066",@"s_sc":@"100",@"s_st":@"1483074130"};
     NSDictionary *params = @{@"lc":@"0000000000000043",@"cc":@"TG0001",@"cv":@"IK3.8.10_Iphone",@"proto":@"7",@"idfa":@"00000000-0000-0000-0000-000000000000",@"idfv":@"73A74722-B15B-48E1-8246-BBF344D3FA8C",@"devi":@"49ada13d88c4c6e87b0d5cc7c510fbb900bb2904",@"osversion":@"ios_10.100000",@"ua":@"iPhone7_2",@"imei":@"",@"imsi":@"",@"uid":@"313054160",@"sid":@"20gPQiPAyqHk3D22keDdi0Q2cAXeLtFWsAju4Rhm9cZ9TcKzi1Vfe",@"conn":@"wifi",@"mtid":@"e7d80f17b447125143549330ee05cb30",@"mtxid":@"80e650124b1a",@"logid":@"133,5",@"s_sg":@"306945c8aa66f792a61f08a3f19b8e29",@"s_sc":@"100",@"s_st":@"1483079664"};
    [HttpTool getWithPath:API_LIVE_TICKER params:params success:^(id json) {
        if ([json[@"dm_error"]integerValue]) {
            failed(json[@"error_msg"]);
        } else {
            // get correct data
            NSArray *ticker = [SamTickers mj_objectArrayWithKeyValuesArray:json[@"ticker"]];
            success(ticker);
        }
    } failure:^(NSError *error) {
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
