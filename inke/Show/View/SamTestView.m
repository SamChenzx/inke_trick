//
//  SamTestView.m
//  inke
//
//  Created by Sam on 12/25/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTestView.h"

@implementation SamTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SamTestView class]) owner:self options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}


@end
