//
//  SamNearbyHeaderView.h
//  inke
//
//  Created by Sam on 12/25/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SamNearbyHeaderView;

@protocol SamHeaderViewDelegate <NSObject>

- (void)headerView:(SamNearbyHeaderView *)headerView clickFilterGender:(UIButton *)button;

@end

@interface SamNearbyHeaderView : UICollectionReusableView

@property(nonatomic, strong) UILabel * title;
@property(nonatomic, assign) id<SamHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *filterGender;

+ (instancetype)loadHeaderView;
- (instancetype)initWithFrame:(CGRect)frame;

@end
