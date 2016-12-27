//
//  SamScrollPageView.m
//  inke
//
//  Created by Sam on 12/25/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamScrollPageView.h"

@interface SamScrollPageView ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *contentPageControl;


@end

@implementation SamScrollPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)loadScrollPageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SamScrollPageView class]) owner:self options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*6, 170);
    
}


@end
