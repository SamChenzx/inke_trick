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

@interface SamShortVideosViewController () <WKUIDelegate,WKNavigationDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *header;

@end

@implementation SamShortVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationItem.title = @"短视频";
    
    // progress bar
  
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"向下拉我";
    return cell;
}

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark WKWebView delegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

@end
