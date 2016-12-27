//
//  SamLocationManager.h
//  inke
//
//  Created by Sam on 12/12/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationBlock)(NSString *lat, NSString *lon);

@interface SamLocationManager : NSObject

+ (instancetype) sharedManager;

- (void) getGPS:(LocationBlock) block;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

@end
