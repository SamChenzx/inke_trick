//
//  SamTabBar.m
//  inke
//
//  Created by Sam on 11/29/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTabBar.h"

@interface SamTabBar()

@property(nonatomic, strong) UIImageView *tabbgView;
@property(nonatomic, strong) NSArray *datalist;
@property(nonatomic, strong) UIButton *lastItem;

@end

@implementation SamTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(NSArray *)datalist
{
    if (!_datalist) {
        _datalist = @[@"tab_live",@"tab_me"];
    }
    return _datalist;
}

-(UIImageView *)tabbgView
{
    if (!_tabbgView) {
        _tabbgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _tabbgView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // add background
        [self addSubview:self.tabbgView];
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
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tabbgView.frame = self.frame;
    CGFloat width = self.frame.size.width/self.datalist.count;
    
    for (NSInteger i = 0; i<[self subviews].count; i++) {
        UIView *btn = [self subviews][i];
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame = CGRectMake((btn.tag - SamItemTypeLive)*width, 0, width, self.frame.size.height);
        }
    }
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
    
    self.lastItem.selected = NO;
    button.selected = YES;
    self.lastItem = button;
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
