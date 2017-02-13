//
//  SamTickerActionsViewController.m
//  inke
//
//  Created by Sam on 1/5/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import "SamTickerActionsViewController.h"
#import <WebKit/WebKit.h>
#import "SamTabBarViewController.h"

@interface SamTickerActionsViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation SamTickerActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // progress bar
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.tintColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor greenColor];
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
    
    
    self.navigationController.navigationBar.topItem.title = @"";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationItem.title = @"what we got?";
    
//    NSLog(@"self.navigationController.interactivePopGestureRecognizer:%@",self.navigationController.interactivePopGestureRecognizer);
//    unsigned int count = 0;
//    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar _var = *(var + i);
//        NSLog(@"ivar_getTypeEncoding:%s",ivar_getTypeEncoding(_var));
//        NSLog(@"ivar_getName:%s",ivar_getName(_var));
//    }
//    NSMutableArray *_targets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"_targets"];
//    NSLog(@"_targets:%@",_targets);
//    NSLog(@"_targets.count:%ld",_targets.count);
//    NSLog(@"_targets[0]:%@",_targets[0]);
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIGestureRecognizer *gesture = self.navigationController.interactivePopGestureRecognizer;
//        gesture.enabled = NO;
//        UIView *gestureView = gesture.view;
//        NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
//        id gestureRecognizerTarget = [_targets firstObject];
//        id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"target"];
//        SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
//        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:handleTransition];
//        [gestureView addGestureRecognizer:popRecognizer];
//    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqual:@"estimatedProgress"] && [object isKindOfClass:[WKWebView class]]) {
        self.progressView.progress = [change[@"new"] floatValue];
//        NSLog(@"change[new]:%f",[change[@"new"] floatValue]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.6 animations:^{
                 self.progressView.progress = [change[@"new"] floatValue];
            }];
            if (self.progressView.progress == 1.0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    self.progressView.hidden = YES;
                });
            } else {
                self.progressView.hidden = NO;
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
