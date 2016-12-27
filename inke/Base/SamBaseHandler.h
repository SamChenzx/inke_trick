//
//  SamBaseHandler.h
//  inke
//
//  Created by Sam on 12/7/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  handle completion event
 */
typedef void (^CompletionBlock)();

/*
 *  handle success event
 *  @param obj return value
 */
typedef void (^SuccessBlock)(id obj);

/*
 *  handle failed event
 *  @param obj error information
 */
typedef void (^FailedBlock)(id obj);

@interface SamBaseHandler : NSObject


@end
