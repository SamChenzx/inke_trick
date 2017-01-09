//
//  SamBaseNavViewController.m
//  inke
//
//  Created by Sam on 11/30/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamBaseNavViewController.h"

@interface SamBaseNavViewController () <UIGestureRecognizerDelegate>

@end

@implementation SamBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0 green:216 blue:201 alpha:1];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
        gesture.enabled = NO;
        UIView *gestureView = gesture.view;
        NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
        id gestureRecognizerTarget = [_targets firstObject];
        id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"target"];
        SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:handleTransition];
        popRecognizer.delegate = self;
        [gestureView addGestureRecognizer:popRecognizer];
    });
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark gestureRecognizer Delegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL boolValue = NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        if (velocity.x > 0) {
                boolValue = self.viewControllers.count!= 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
        }
    }
    return boolValue;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
