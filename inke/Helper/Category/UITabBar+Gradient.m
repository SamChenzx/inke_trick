
//
//  UITabBar+Gradient.m
//  FJGradientNavigationAndStatusBar
//
//  Created by fjf on 16/6/13.
//  Copyright © 2016年 fjf. All rights reserved.
//

#import "UITabBar+Gradient.h"

@implementation UITabBar (Gradient)

- (void)fj_setTranslationY:(CGFloat)translationY {
    CGFloat transfromTy = self.transform.ty - translationY;
    if (transfromTy > self.frame.size.height) {
        transfromTy = self.frame.size.height;
    }else if(transfromTy < 0){
        transfromTy = 0;
    }
    self.transform = CGAffineTransformMakeTranslation(0, transfromTy);
}

- (void)fj_moveByTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


- (void)fj_setImageViewAlpha:(CGFloat)alpha {
    self.alpha = alpha;
}

@end
