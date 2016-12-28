//
//  SamActivitiesView.m
//  inke
//
//  Created by Sam on 12/27/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamActivitiesView.h"

@interface SamActivitiesView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView, *middleImageView, *rightImageView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger scrollerViewWidth, scrollerViewHeight;
@property (nonatomic, strong) NSMutableArray *dataList;


@end

@implementation SamActivitiesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype) loadActivitiesView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];

}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3);
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight*0.3);
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.frame.size.height)];
    self.leftImageView.image = [UIImage imageNamed:@"default_activities_empty"];
    self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.frame.size.height)];
    self.middleImageView.image = [UIImage imageNamed:@"default_activities_empty"];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.scrollView.frame.size.height)];
    self.rightImageView.image = [UIImage imageNamed:@"default_activities_empty"];
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}



@end
