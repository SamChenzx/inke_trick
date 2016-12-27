//
//  SamLiveHandler.h
//  inke
//
//  Created by Sam on 12/7/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamBaseHandler.h"

@interface SamLiveHandler : SamBaseHandler

/**
 * Get hot live information
 * @param success
 * @param failed
 **/
+(void) executeGetHotLiveTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed;


/**
 * Get nearby live information
 * @param success
 * @param failed
 **/
+(void) executeGetNearbyLiveTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed;

/**
 * Get advertise information
 * @param success
 * @param failed
 **/
+(void) executeGetAdvertiseTaskWithSuccess:(SuccessBlock) success failed:(FailedBlock) failed;

@end
