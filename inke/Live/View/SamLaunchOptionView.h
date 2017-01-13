//
//  SamLaunchOptionView.h
//  inke
//
//  Created by Sam on 1/12/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SamLaunchType) {
    SamLaunchTypeCamera = 100,  // Use camera to live
    SamLaunchTypeVideo,         // Publish shot videos
};

@class SamLaunchOptionView;

@protocol SamLaunchOptionDelegate <NSObject>

- (void) launchOptionView:(SamLaunchOptionView *)launchOptionView clickButtonAtIndex:(SamLaunchType) index;

@end

@interface SamLaunchOptionView : UIView

@property (nonatomic, assign) id<SamLaunchOptionDelegate> delegate;

- (void)showUp;

@end
