//
//  SamMeInfoView.m
//  inke
//
//  Created by Sam on 12/22/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamMeInfoView.h"

@interface SamMeInfoView ()

@end

@implementation SamMeInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)loadInfoView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}



@end
