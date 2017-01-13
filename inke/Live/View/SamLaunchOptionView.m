//
//  SamLaunchOptionView.m
//  inke
//
//  Created by Sam on 1/12/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import "SamLaunchOptionView.h"

#define HightForLaunchOptionView 210

@interface SamLaunchOptionView()

@property(nonatomic, strong) UIView *optionView;
@property(nonatomic, strong) NSArray *dataList;

@end

@implementation SamLaunchOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSArray arrayWithObjects:@"shortvideo_main_live",@"直播",@"shortvideo_main_video",@"短视频", nil];
    }
    return _dataList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
        self.optionView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - HightForLaunchOptionView, kScreenWidth, HightForLaunchOptionView)];
        [self.optionView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1]];

        for (NSInteger i = 0; i < self.dataList.count/2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(56.25 + i*kScreenWidth / 2, 25, 75, 75)];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:self.dataList[i*2]] forState:UIControlStateNormal];
//            [button sizeToFit];
            button.tag = SamLaunchTypeCamera+i;
//            UILabel *buttonTitle = [[UILabel alloc] initWithFrame:CGRectMake(56.25 + i*kScreenWidth / 2, 105, 75, 30)];
            UILabel *buttonTitle = [[UILabel alloc] init];
            buttonTitle.text = self.dataList[i*2+1];
            buttonTitle.textAlignment = NSTextAlignmentCenter;
            buttonTitle.font = [UIFont systemFontOfSize:14];
            [button addSubview:buttonTitle];
            [buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(button.mas_bottom);
                make.centerX.equalTo(button.mas_centerX);
            }];
            [self.optionView addSubview:button];
        }
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, HightForLaunchOptionView - 50, kScreenWidth, 50)];
        [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shortvideo_launch_close"]];
        [closeButton addSubview:closeImage];
        [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(closeButton.mas_centerX);
            make.centerY.equalTo(closeButton.mas_centerY);
        }];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [self.optionView addSubview:closeButton];
    }
    [self addSubview:self.optionView];
    return self;
}

- (void)showUp
{
    self.optionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, HightForLaunchOptionView);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.optionView.frame = CGRectMake(0, kScreenHeight - HightForLaunchOptionView, kScreenWidth, HightForLaunchOptionView);
    } completion:nil];
    
    for (NSInteger i = 0; i<self.optionView.subviews.count; i++)
    {
        UIView *view = self.optionView.subviews[i];
        if ([view isKindOfClass:[UIButton class]])
        {
            CGRect frame = view.frame;
            if (frame.size.width == 75) {
                view.frame = CGRectMake(56.25 + i*kScreenWidth / 2, 0, 75, 75);
                [UIView animateWithDuration:1 delay:0.1*i usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn| UIViewAnimationOptionAllowUserInteraction animations:^{
                    view.frame = frame;
                } completion:nil];
            }
        }
    }
}

- (void)clickButton: (UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(launchOptionView:clickButtonAtIndex:)]) {
        [self.delegate launchOptionView:self clickButtonAtIndex:button.tag];
        [self dismissView];
    }
}

- (void)clickCloseButton: (UIButton *)button
{
    [self dismissView];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.optionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, HightForLaunchOptionView);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:self];
    
    CGFloat deltaY = currentPosition.y;
    if (deltaY<(kScreenHeight-HightForLaunchOptionView))
    {
        [self dismissView];
    }
}

@end
