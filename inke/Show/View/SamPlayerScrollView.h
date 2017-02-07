//
//  SamPlayerScrollView.h
//  inke
//
//  Created by Sam on 2/7/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SamPlayerScrollView;

@protocol SamPlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(SamPlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;

@end

@interface SamPlayerScrollView : UIScrollView

@property (nonatomic, assign) id<SamPlayerScrollViewDelegate> playerDelegate;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;

@end

