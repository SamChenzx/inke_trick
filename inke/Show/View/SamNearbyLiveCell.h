//
//  SamNearbyLiveCell.h
//  inke
//
//  Created by Sam on 12/12/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SamLive.h"

@interface SamNearbyLiveCell : UICollectionViewCell

@property (nonatomic, strong) SamLive * live;

- (void)showAnimation;

@end
