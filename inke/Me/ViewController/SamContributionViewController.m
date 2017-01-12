//
//  SamContributionViewController.m
//  inke
//
//  Created by Sam on 12/23/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamContributionViewController.h"
#import "SamTestView.h"
#import "SamTickersView.h"
#import "SamTickers.h"
#import "SamLiveHandler.h"
#import "SamTickerActionsViewController.h"

@interface SamContributionViewController () <SamTickersDelegate>

@property(nonatomic, strong) SamTickersView *tickersView;
@property(nonatomic, strong) NSMutableArray *imageAndLinkArray;

@end

@implementation SamContributionViewController

#pragma mark - SamtickersDelegate

-(NSMutableArray *)imageAndLinkArray
{
    if (!_imageAndLinkArray) {
        _imageAndLinkArray = [NSMutableArray array];
        if (!_imageAndLinkArray) {
            for (int i = 0; i < 7; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
                [_imageAndLinkArray addObject:image];
            }
        }
        
    }
    return _imageAndLinkArray;
}

-(void) initUI
{
    self.tickersView = [SamTickersView loadTickersView];
    [self.view addSubview:self.tickersView];
    self.tickersView.frame = CGRectMake(0, 150, kScreenWidth, 125);
    self.tickersView.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"";

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationItem.title = @"映票贡献榜";

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTickerOfTickersView:)];
    [self.tickersView addGestureRecognizer:tapGesture];

}

- (void)clickTickerOfTickersView:(UITapGestureRecognizer *)tapGesture
{
    SamTickerActionsViewController *actionVC = [[SamTickerActionsViewController alloc]init];
    actionVC.urlString = [self.tickersView LinkAtCurrentPageIndex];
    [self.navigationController pushViewController:actionVC animated:YES];
}

-(void) loadData
{
        [SamLiveHandler executeGetTickersTaskWithSuccess:^(id obj) {
        [self.imageAndLinkArray removeAllObjects];
        [self.imageAndLinkArray addObjectsFromArray:obj];
        [self.tickersView updateForImagesAndLinks:_imageAndLinkArray];
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

-(void)viewWillLayoutSubviews
{
    self.tickersView.frame = CGRectMake(0, 150, kScreenWidth, 125);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self loadData];
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
