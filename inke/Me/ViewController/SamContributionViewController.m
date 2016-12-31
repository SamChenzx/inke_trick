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
        //        [SamLiveHandler executeGetTickersTaskWithSuccess:^(id obj) {
        //            [_imageAndLinkArray removeAllObjects];
        //            [_imageAndLinkArray addObjectsFromArray:obj];
        //            [self.tickersView updateForImagesAndLinks:_imageAndLinkArray];
        //            //NSLog(@"_imageAndLinkArray init: %@",_imageAndLinkArray);
        //        } failed:^(id obj) {
        //            NSLog(@"%@",obj);
        //        }];
        // if failed to get tickers from internet, load images from local.
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
    self.tickersView.delegate = self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tickers = [[SamtickersView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight*0.3)];
    [self initUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
