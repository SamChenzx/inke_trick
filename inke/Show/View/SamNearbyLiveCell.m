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
}

-(void)setLive:(SamLive *)live
{
    _live = live;
    if (![live.creator.portrait hasPrefix:IMAGE_SERVER_HOST]) {
        live.creator.portrait = [IMAGE_SERVER_HOST stringByAppendingString:live.creator.portrait];
    }
    [self.headView downloadImage:live.creator.portrait placeholder:@"default_room"];
    self.distanceLabel.text = live.distance;
}

- (void)showAnimation
{
    if (self.live.isShow) {
        return;
    }
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    self.live.show = YES;
}

@end
