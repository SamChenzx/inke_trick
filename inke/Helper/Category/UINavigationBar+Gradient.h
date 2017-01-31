//
//  UINavigationBar+Gradient.h
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStatusType) {
    NavigationBarStatusOfTypeNormal = 0,
    NavigationBarStatusOfTypeHidden,
    NavigationBarStatusOfTypeShow,
};

@interface UINavigationBar (Gradient)

// 设置背景图透明度
- (void)fj_setImageViewAlpha:(CGFloat)alpha;
// 根据translationY在原来位置上偏移
- (void)fj_setTranslationY:(CGFloat)translationY;
// 设置偏移translationY
- (void)fj_moveByTranslationY:(CGFloat)translationY;

@end
