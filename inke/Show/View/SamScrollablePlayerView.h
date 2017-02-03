//
//  SamScrollablePlayerView.h
//  inke
//
//  Created by Sam on 2/2/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SamScrollablePlayerView;

@protocol SamScrollablePlayerViewDelegate <NSObject>

- (NSMutableArray *)preparePlayerData;
- (void)scrollablePlayerView:(SamScrollablePlayerView *)scrollablePlayerView currentPlayIndex:(NSInteger)index;

@end

@interface SamScrollablePlayerView : UIView

@property (nonatomic, assign) id<SamScrollablePlayerViewDelegate> playerDelegate;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIScrollView *playerScrollView;

+ (instancetype)loadScrollablePlayerView;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;

@end
