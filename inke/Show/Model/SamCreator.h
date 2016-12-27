//
//  SamCreator.h
//  inke
//
//  Created by Sam on 12/7/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SamCreator : NSObject

@property (nonatomic, strong) NSString * birth;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * emotion;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger gmutex;
@property (nonatomic, strong) NSString * hometown;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger inkeVerify;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * portrait;
//@property (nonatomic, strong) NSString * hostPortrait;
@property (nonatomic, strong) NSString * profession;
@property (nonatomic, assign) NSInteger rankVeri;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * thirdPlatform;
@property (nonatomic, strong) NSString * veriInfo;
@property (nonatomic, assign) NSInteger verified;
@property (nonatomic, strong) NSString * verifiedReason;

@end
