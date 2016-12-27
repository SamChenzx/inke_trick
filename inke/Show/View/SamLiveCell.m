//
//  SamLiveCell.m
//  inke
//
//  Created by Sam on 12/8/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLiveCell.h"

@interface SamLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;



@end

@implementation SamLiveCell


-(void)setLive:(SamLive *)live
{
    _live = live;
    
    self.nameLabel.text = live.creator.nick;
    self.locationLabel.text = live.creator.location;
    self.onLineLabel.text = [@(live.onlineUsers) stringValue];
    
    if ([live.creator.portrait isEqualToString:@"Sam"]) {
        self.headView.image = [UIImage imageNamed:@"Sam"];
        self.liveImageView.image = [UIImage imageNamed:@"Sam"];
    } else {
        [self.headView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_HOST,live.creator.portrait] placeholder:@"default_room"];
        [self.liveImageView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_HOST,live.creator.portrait] placeholder:@"default_room"];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = self.headView.bounds.size.height/2.0;
    self.headView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
