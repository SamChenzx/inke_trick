//
//  SamMainTopView.m
//  inke
//
//  Created by Sam on 12/3/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamMainTopView.h"

@interface SamMainTopView ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation SamMainTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonWidth = self.frame.size.width/titles.count;
        CGFloat buttonHeight = self.frame.size.height;
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *vcName = titles[i];
            // set button title
            [titleButton setTitle:vcName forState:UIControlStateNormal];
            [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            titleButton.tag = i;
            
            titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
            titleButton.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight);
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.buttons addObject:titleButton];
            
            [self addSubview:titleButton];
            
            if (i == 1) {
                CGFloat lineHeight = 2;
                CGFloat lineWidth = 40;
                [titleButton.titleLabel sizeToFit];
                self.lineView = [[UIView alloc] init];
                self.lineView.backgroundColor = [UIColor whiteColor];
                self.lineView.frame = CGRectMake(0, 0, titleButton.titleLabel.frame.size.width, lineHeight);
            
                [self.lineView setCenter:CGPointMake(titleButton.center.x, lineWidth)];
                
                [self addSubview:self.lineView];
            }
            
        }
    }
    return self;
}

-(void) titleClick:(UIButton *) button
{
    self.block(button.tag);
    [self scrolling:button.tag];
}

-(void)scrolling:(NSInteger)tag
{
    UIButton *button = self.buttons[tag];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.lineView setCenter:CGPointMake(button.center.x, self.lineView.center.y)];
    }];
}


@end
