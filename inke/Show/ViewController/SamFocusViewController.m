//
//  SamFocusViewController.m
//  inke
//
//  Created by Sam on 12/2/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamFocusViewController.h"
#import "SamLiveCell.h"
#import "SamLive.h"
#import "SamPlayerViewController.h"
#import "SamLiveHandler.h"
#import "SamTickersView.h"
#import "SamTickerActionsViewController.h"
#import "MJRefresh.h"



static NSString * identifier = @"focus";

@interface SamFocusViewController () <SamTickersDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) SamTickersView *tickersView;
@property(nonatomic, strong) NSMutableArray *imageAndLinkArray;

@end

@implementation SamFocusViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self loadData];
    
    [self prepareRefresh];
    
}

-(SamTickersView *)TickersView
{
    if (!_tickersView) {
        _tickersView = [SamTickersView loadTickersView];
    }
    return _tickersView;
}

-(void) initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SamLiveCell" bundle:nil] forCellReuseIdentifier:identifier] ;
    self.tickersView = [SamTickersView loadTickersView];
    self.tickersView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTickerOfTickersView:)];
    [self.tickersView addGestureRecognizer:tapGesture];
    self.tableView.tableHeaderView = self.tickersView;
    self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight + kNavigationBarHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
}


- (void)prepareRefresh
{
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (int i = 1; i < 29; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_00%02d",i]];
        [imagesArray addObject:image];
    }
    MJRefreshGifHeader *gifRefreshHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    gifRefreshHeader.stateLabel.hidden = YES;
    gifRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifRefreshHeader setImages:imagesArray duration:1.5 forState:MJRefreshStateIdle];
    [gifRefreshHeader setImages:imagesArray duration:1.5 forState:MJRefreshStatePulling];
    [gifRefreshHeader setImages:imagesArray duration:1.5 forState:MJRefreshStateRefreshing];
    [gifRefreshHeader setImages:imagesArray duration:1.5 forState:MJRefreshStateNoMoreData];
    self.tableView.mj_header = gifRefreshHeader;
}

- (void)clickTickerOfTickersView:(UITapGestureRecognizer *)tapGesture
{
    SamTickerActionsViewController *actionVC = [[SamTickerActionsViewController alloc]init];
    actionVC.urlString = [self.tickersView LinkAtCurrentPageIndex];
    [self.navigationController pushViewController:actionVC animated:YES];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}

- (void)loadData
{
    SamLive *live = [[SamLive alloc]init];
    live.city = @"杭州";
    live.onlineUsers = 18999;
    live.streamAddr = LIVE_SAM;
    
    SamCreator *creator = [[SamCreator alloc]init];
    creator.nick = @"Sam";
    creator.portrait = @"Sam";
    live.creator = creator;
    
    SamLive *live1 = [[SamLive alloc]init];
    live1.city = @"LA";
    live1.onlineUsers = 17999;
    live1.streamAddr = LIVE_SAM;
    
    SamCreator *creator1 = [[SamCreator alloc]init];
    creator1.nick = @"Joe";
    creator1.portrait = @"Joe";
    live1.creator = creator1;
    
    SamLive *live2 = [[SamLive alloc]init];
    live2.city = @"上海";
    live2.onlineUsers = 16999;
    live2.streamAddr = LIVE_SAM;
    
    SamCreator *creator2 = [[SamCreator alloc]init];
    creator2.nick = @"Ha";
    creator2.portrait = @"Ha";
    live2.creator = creator2;
    
    self.dataList = @[live,live1,live2];
    
    [SamLiveHandler executeGetTickersTaskWithSuccess:^(id obj) {
        [self.imageAndLinkArray removeAllObjects];
        [self.imageAndLinkArray addObjectsFromArray:obj];
        [self.tickersView updateForImagesAndLinks:_imageAndLinkArray];
        if (self.tableView.mj_header.isRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
        }
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
    
    
    [self.tableView reloadData];
}

#pragma mark TableView staff

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataList.count;
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SamLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SamLiveCell" owner:self options:nil] lastObject];
    }
    cell.live = self.dataList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    cellHeight = 70 + [UIScreen mainScreen].bounds.size.width;
    return cellHeight;
}

#pragma mark TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SamLive *live = self.dataList[indexPath.row];
    SamPlayerViewController *playerVC = [[SamPlayerViewController alloc]init];
    playerVC.live = live;
    
    [playerVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:playerVC animated:YES completion:nil];
    
    //    self.parentViewController.view.hidden = YES;
    //    playerVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:playerVC animated:YES];
}

#pragma mark TickersDelegate

-(NSMutableArray *)tickersDataList
{
    return self.imageAndLinkArray;
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
