//
//  SamAdvertiseView.m
//  inke
//
//  Created by Sam on 12/16/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamAdvertiseView.h"
#import "SamLiveHandler.h"
#import "SamAdvertise.h"
#import "SamCacheHelper.h"

@interface SamAdvertiseView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) dispatch_source_t timer;


@end

@implementation SamAdvertiseView

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 30, 78, 20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passAdvertise:)];
        [_timeLabel addGestureRecognizer:tap];
    }
    return _timeLabel;
}

- (void)passAdvertise: (UITapGestureRecognizer *) tap
{
    [self dismiss];
    NSLog(@"tap dismiss advertise");
}

+ (instancetype) loadAdvertiseView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SamAdvertiseView" owner:self options:nil] lastObject];
}

// advertise init
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
    // show advertise
    [self showAdvertise];
    
    // download advertise
    [self downloadAdvertise];
    
    // count down
    [self timerCountDown];
}

- (void)showAdvertise
{
    NSString * fileName = [SamCacheHelper getAdvertise];
    NSString * filePath = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER_HOST,fileName];
    UIImage * latestCacheImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:filePath];
    if (latestCacheImage) {
        self.backImageView.image = latestCacheImage;
    }
    else
    {
        //self.hidden = YES;
        self.backImageView.image = [UIImage imageNamed:@"advertiseImage"];
    }
    [self addSubview:self.timeLabel];
}

- (void)downloadAdvertise
{
    [SamLiveHandler executeGetAdvertiseTaskWithSuccess:^(id obj) {
        SamAdvertise * advertise = obj;
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_HOST,advertise.image]];
        [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            NSLog(@"success to download image");
            
            [SamCacheHelper setAdvertise:advertise.image];
        }];
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

- (void)timerCountDown
{
    __block NSInteger timeOut = 0.3;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut<=0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"跳过：%ld",timeOut];
            });
            timeOut--;
        }
        
    });
    dispatch_resume(timer);
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
