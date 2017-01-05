//
//  SamTabBar.m
//  inke
//
//  Created by Sam on 11/29/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTabBar.h"

@interface SamTabBar()

@property(nonatomic, strong) NSArray *datalist;
@property(nonatomic, strong) UIButton *lastItem;
@property(nonatomic, strong) UIButton *cameraButton;

@end

@implementation SamTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)cameraButton {
    
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_cameraButton sizeToFit];
        
        [_cameraButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.tag = SamItemTypeLaunch;
    }
    return _cameraButton;
}


-(NSArray *)datalist
{
    if (!_datalist) {
        _datalist = @[@"tab_live",@"tab_me"];
    }
    return _datalist;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backGroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
        backGroundImage.frame = frame;
        [self addSubview:backGroundImage];
        [self setBackgroundColor:[UIColor whiteColor]];
        // add items
        for (NSInteger i = 0; i<self.datalist.count; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.adjustsImageWhenHighlighted = NO;
            [item setImage:[UIImage imageNamed:self.datalist[i]] forState:UIControlStateNormal];
            
            [item setImage:[UIImage imageNamed:[self.datalist[i] stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            if (i == 0) {
                item.selected = YES;
                self.lastItem = item;
            }
            item.tag = SamItemTypeLive + i;
            [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
        }
    }
    [self addSubview:self.cameraButton];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width/self.datalist.count;
    
    for (NSInteger i = 0; i<[self subviews].count; i++) {
        UIView *btn = [self subviews][i];
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame = CGRectMake((btn.tag - SamItemTypeLive)*width, 0, width, self.frame.size.height);
        }
    }
    
    [self.cameraButton sizeToFit];
    self.cameraButton.center = CGPointMake(self.frame.size.width/2, 10);
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

-(void)clickItem:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:clickButton:)]) {
        [self.delegate tabBar:self clickButton:button.tag];
    }
    //!self.block?:self.block(self,button.tag);
    if (self.block) {
        self.block(self,button.tag);
    }
    if (button.tag == SamItemTypeLaunch) {
        return;
    }
    
//    self.lastItem.selected = NO;
    button.selected = YES;
//    self.lastItem = button;
    [UIView animateWithDuration:0.2
                     animations:^{
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2
                         animations:^{
            button.transform = CGAffineTransformIdentity;
        }];
    }];
}


@end
