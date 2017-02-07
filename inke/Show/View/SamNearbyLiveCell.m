//
//  SamNearbyLiveCell.m
//  inke
//
//  Created by Sam on 12/12/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamNearbyLiveCell.h"

@interface SamNearbyLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation SamNearbyLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.distanceLabel.backgroundColor = [UIColor whiteColor];
    self.distanceLabel.layer.masksToBounds = YES;
}

-(void)setLive:(SamLive *)live
{
    _live = live;
    self.distanceLabel.text = live.distance;
}

- (void)updateImageForCellWithLive:(SamLive *)live
{
    if (![live.creator.portrait hasPrefix:IMAGE_SERVER_HOST]) {
        live.creator.portrait = [IMAGE_SERVER_HOST stringByAppendingString:live.creator.portrait];
    }
    [self.headView downloadImage:live.creator.portrait placeholder:@"default_room"];
}

- (void)showAnimation
{
    if (self.live.isShow) {
        return;
    }
    self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    self.live.show = YES;
}

@end
