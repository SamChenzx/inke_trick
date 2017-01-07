//
//  SamTabBar.h
//  inke
//
//  Created by Sam on 11/29/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SamItemType) {
    
    SamItemTypeLaunch = 10,// Launch live
    SamItemTypeLive = 100, // show live
    SamItemTypeMe,         // show me
};

@class SamTabBar;

typedef void(^TabBlock)(SamTabBar *tabBar, SamItemType index);

@protocol SamTabBarDelegate <NSObject>

-(void)tabBar:(SamTabBar *)tabBar clickButton:(SamItemType) index;

@end

@interface SamTabBar : UITabBar

@property(nonatomic, assign) id<SamTabBarDelegate> delegate;
@property(nonatomic, copy) TabBlock block;

@end
