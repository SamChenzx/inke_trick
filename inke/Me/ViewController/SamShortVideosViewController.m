//
//  SamShortVideosViewController.m
//  inke
//
//  Created by Sam on 1/4/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import "SamShortVideosViewController.h"
#import <WebKit/WebKit.h>

#define kScreenbounds [UIScreen mainScreen].bounds
#define pictureHeight 200

@interface SamShortVideosViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) UINavigationItem *privateNavigationItem;
@property (nonatomic, strong) UINavigationBar *privateNavigationBar;

@end

@implementation SamShortVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
  
}

- (void)initUI {
    
    // navigationBar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.privateNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, kScreenWidth, 64)];
    [self.privateNavigationBar setTitleTextAttributes:attributes];
    [self.privateNavigationBar setTintColor:[UIColor whiteColor]];
    [self.privateNavigationBar setBarTintColor:[UIColor colorWithRed:36.0/255.0 green:215.0/255.0 blue:200.0/255.0 alpha:1]];
    self.privateNavigationItem = [[UINavigationItem alloc] initWithTitle:@"短视频"];
    self.privateNavigationItem.leftBarButtonItem = leftItem;
    [self.privateNavigationBar setItems:@[self.privateNavigationItem]];
    [self.view addSubview:self.privateNavigationBar];

    // webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, kScreenWidth, kScreenHeight-64)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:@"https://sv.baidu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // progress bar
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 3)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.tintColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor greenColor];
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
}

- (void)clickBack:(UIBarButtonItem *)item {
    NSLog(@"should go back");
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)createTableView
//{
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    
//    // 添加头视图 在头视图上添加ImageView
//    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, pictureHeight)];
//    _pictureImageView = [[UIImageView alloc] initWithFrame:_header.bounds];
//    _pictureImageView.image = [UIImage imageNamed:@"5"];
//    /*
//     重要的属性设置
//     */
//    //这个属性的值决定了 当视图的几何形状变化时如何复用它的内容 这里用 UIViewContentModeScaleAspectFill 意思是保持内容高宽比 缩放内容 超出视图的部分内容会被裁减 填充UIView
//    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
//    // 这个属性决定了子视图的显示范围 取值为YES时，剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
//    _pictureImageView.clipsToBounds = YES;
//    [_header addSubview:_pictureImageView];
//    self.tableView.tableHeaderView = _header;
//    [self.view addSubview:_tableView];
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return 20;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.textLabel.text = @"向下拉我";
//    return cell;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    /**
//     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
//     */
//    
//    // 获取到tableView偏移量
//    CGFloat Offset_y = scrollView.contentOffset.y;
//    // 下拉 纵向偏移量变小 变成负的
//    if ( Offset_y < 0) {
//        // 拉伸后图片的高度
//        CGFloat totalOffset = pictureHeight - Offset_y;
//        // 图片放大比例
//        CGFloat scale = totalOffset / pictureHeight;
//        CGFloat width = kScreenWidth;
//        // 拉伸后图片位置
//        _pictureImageView.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
//    }
//    
//}

#pragma mark WKWebView delegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
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


@end
