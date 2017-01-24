//
//  UILabel+SamAlertActionFont.m
//  inke
//
//  Created by Sam on 1/24/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import "UILabel+SamAlertActionFont.h"

@implementation UILabel (SamAlertActionFont)

- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if (appearanceFont) {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}


@end
