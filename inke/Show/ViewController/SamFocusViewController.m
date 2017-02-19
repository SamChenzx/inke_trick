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

@interface SamFocusViewController () <SamTickersDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) SamTickersView *tickersView;
@property(nonatomic, strong) NSMutableArray *imageAndLinkArray;

@end

@implementation SamFocusViewController


-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
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
        [_dataList removeAllObjects];
        [_dataList addObjectsFromArray:@[live, live1, live2]];
    }
    
    return _dataList;
}

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

-(SamTickersView *)TickersView
{
    if (!_tickersView) {
        _tickersView = [SamTickersView loadTickersView];
    }
    return _tickersView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self prepareRefresh];
    DLog(@"I'm here");
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
    self.tableView.rowHeight = 70 + [UIScreen mainScreen].bounds.size.width;
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
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    });
    if (self.tableView.mj_header.isRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
    
    [SamLiveHandler executeGetTickersTaskWithSuccess:^(id obj) {
        [self.imageAndLinkArray removeAllObjects];
        [self.imageAndLinkArray addObjectsFromArray:obj];
        [self.tickersView updateForImagesAndLinks:_imageAndLinkArray];
        
        [self.tableView reloadData];
        
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

#pragma mark TableView staff

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataList.count;
    return self.dataList.count;
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

#pragma mark TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SamLive *live = self.dataList[indexPath.row];
    SamPlayerViewController *playerVC = [[SamPlayerViewController alloc]init];
    playerVC.dataList = self.dataList;
    playerVC.live = live;
    playerVC.index = indexPath.row;
    
    [playerVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:playerVC animated:YES completion:nil];
    
    //    self.parentViewController.view.hidden = YES;
    //    playerVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:playerVC animated:YES];
}


@end
