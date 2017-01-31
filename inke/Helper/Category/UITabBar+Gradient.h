//
//  UITabBar+Gradient.h
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StatusBarStatusType) {
    StatusBarStatusTypeOfNormal = 0,
    StatusBarStatusTypeOfHidden,
    StatusBarStatusTypeOfShow,
};

@interface UITabBar (Gradient)
- (void)fj_setImageViewAlpha:(CGFloat)alpha;

- (void)fj_setTranslationY:(CGFloat)translationY;

- (void)fj_moveByTranslationY:(CGFloat)translationY;
@end
