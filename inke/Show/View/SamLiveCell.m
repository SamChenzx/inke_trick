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
@property (nonatomic, strong) NSArray * defaultName;



@end

@implementation SamLiveCell

- (NSArray *)defaultName
{
    if (!_defaultName) {
        _defaultName = [[NSArray alloc] initWithObjects:@"Sam",@"Joe",@"Ha", nil];
    }
    return _defaultName;
}

-(void)setLive:(SamLive *)live
{
    _live = live;
    
    self.nameLabel.text = live.creator.nick;
    self.locationLabel.text = live.creator.location;
    self.onLineLabel.text = [@(live.onlineUsers) stringValue];
    
    if ([self.defaultName containsObject:live.creator.portrait] ) {
        
        
        
        self.headView.image = [UIImage imageNamed:live.creator.portrait];
        self.liveImageView.image = [UIImage imageNamed:live.creator.portrait];
    } else {
        if (![live.creator.portrait hasPrefix:IMAGE_SERVER_HOST]) {
            live.creator.portrait = [IMAGE_SERVER_HOST stringByAppendingString:live.creator.portrait];
        }
        [self.headView downloadImage:live.creator.portrait placeholder:@"default_room"];
        [self.liveImageView downloadImage:live.creator.portrait placeholder:@"default_room"];
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
