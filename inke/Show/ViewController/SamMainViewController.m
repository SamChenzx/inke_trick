//
//  SamMainViewController.m
//  inke
//
//  Created by Sam on 11/30/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamMainViewController.h"
#import "SamMainTopView.h"

@interface SamMainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *datalist;

@property (nonatomic, strong) SamMainTopView *topView;

@end

@implementation SamMainViewController


-(NSArray *)datalist
{
    if (!_datalist) {
        _datalist = @[@"关注",@"热门",@"附近"];
    }
    return _datalist;
}

-(SamMainTopView *)topView
{
    if (!_topView) {
        _topView = [[SamMainTopView alloc]initWithFrame:CGRectMake(0, 0, 200, 50) titleNames:self.datalist];
        
        @weakify(self);
        
        _topView.block = ^(NSInteger tag)
        {
            @strongify(self);
            CGPoint point = CGPointMake(tag*([UIScreen mainScreen].bounds.size.width), self.contentScrollView.contentOffset.y);
            [self.contentScrollView setContentOffset:point animated:YES];
        };
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];

}



-(void) initUI
{
    // add left right button item
    [self setupNav];
    // add subviews controller
    [self setupChildViewControllers];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void) setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"global_search"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_more"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.titleView = self.topView;
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void) setupChildViewControllers
{
    NSArray *vcNames = @[@"SamFocusViewController",@"SamHotViewController",@"SamNearbyViewController"];
    for (NSInteger i = 0; i < vcNames.count; i++) {
        NSString *vcName = vcNames[i];
        UIViewController *vc = [[NSClassFromString(vcName) alloc]init];
        vc.title = self.datalist[i];
        [self addChildViewController:vc];
    }
    
    // add child viewcontroller to mainVC's scrollview
    
    // setup scrollview content size
    self.contentScrollView.contentSize =CGSizeMake(([UIScreen mainScreen].bounds.size.width)*self.datalist.count, 0);
    self.contentScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width,0);
    self.contentScrollView.autoresizesSubviews = NO;
    [self.contentScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    // Add views for scrollView
    for (NSInteger i = 0; i < vcNames.count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        [self.contentScrollView addSubview:vc.view];
    }
}

#pragma mark - ScrollView delegate
// end animation
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset = scrollView.contentOffset.x;
    // get index
    NSInteger index = offset/width;
    
    // index to move button line
    [self.topView scrolling:index];
    
    // get view controller according index
    UIViewController *vc = self.childViewControllers[index];
    // test if vc has execute viewDidLoaded
    if ([vc isViewLoaded]) {
        return;
    } else {
        if (self.navigationController.navigationBar.frame.origin.y < 0) {
            self.contentScrollView.frame = CGRectMake(offset, -64, width, height);
        }
            vc.view.frame = CGRectMake(offset, 0, width, height);
        
        // add child view controller to scroll view
        [scrollView addSubview:vc.view];
    }
}

// end decelerating init child view controller
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
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
