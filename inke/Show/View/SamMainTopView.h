//
//  SamMainTopView.h
//  inke
//
//  Created by Sam on 12/3/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MainTopBlock)(NSInteger tag);

@interface SamMainTopView : UIView

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles;

-(void) scrolling:(NSInteger) tag;

@property (nonatomic, copy) MainTopBlock block;

@end
