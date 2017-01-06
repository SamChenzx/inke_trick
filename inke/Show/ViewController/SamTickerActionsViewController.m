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
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 3)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"what we got?";//self.urlString;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:22];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.titleView = titleLabel;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    SamTabBarViewController * STBVC =(SamTabBarViewController *) window.rootViewController;
    STBVC.samTabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)setLoadCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
    
    if (totalCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (totalCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
        
    }
}



- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.totalCount ++;
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.totalCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.totalCount --;
    NSLog(@"%@",error);
}



//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:YES];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    SamTabBarViewController * STBVC =(SamTabBarViewController *) window.rootViewController;
//    STBVC.samTabBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
// 
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
