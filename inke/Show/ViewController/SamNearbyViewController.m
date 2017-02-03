//
//  SamNearbyViewController.m
//  inke
//
//  Created by Sam on 12/2/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamNearbyViewController.h"
#import "SamLiveHandler.h"
#import "SamNearbyLiveCell.h"
#import "SamPlayerViewController.h"
#import "SamNearbyHeaderView.h"
#import "UILabel+SamAlertActionFont.h"
#import "MJRefresh.h"

static NSString *identifier = @"SamNearbyLiveCell";

#define kMargin 5
#define kItemWidth 100


@interface SamNearbyViewController() <UICollectionViewDelegate,UICollectionViewDataSource,SamHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger genderIndex;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation SamNearbyViewController

- (NSArray *)titles
{
    if (!_titles) {
        _titles = [[NSArray alloc] initWithObjects:@"看全部",@"只看女",@"只看男", nil];
    }
    return _titles;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [self loadData];
    [self prepareRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)initUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"SamNearbyLiveCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SamNearbyHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
    UIFont *font = [UIFont systemFontOfSize:14];
    [appearanceLabel setAppearanceFont:font];
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
    [gifRefreshHeader setImages:imagesArray forState:MJRefreshStateIdle];
    [gifRefreshHeader setImages:imagesArray forState:MJRefreshStatePulling];
    [gifRefreshHeader setImages:imagesArray forState:MJRefreshStateRefreshing];
    [gifRefreshHeader setImages:imagesArray forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_header = gifRefreshHeader;
}

- (void)loadData
{
    [SamLiveHandler executeGetNearbyLiveTaskWithSuccess:^(id obj) {
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:obj];
        [self.collectionView reloadData];
        if (self.collectionView.mj_header.isRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView.mj_header endRefreshing];
            });
        }
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

#pragma mark collectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SamNearbyLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.live = self.dataList[indexPath.row];
    return cell;
}

- (CGSize)collectionView: (UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger count = self.collectionView.width / kItemWidth;
    CGFloat cellWidth = (self.collectionView.width - kMargin*(count+1))/count;
    return CGSizeMake(cellWidth, cellWidth+20);
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SamNearbyLiveCell *myCell = (SamNearbyLiveCell *)cell;
    [myCell showAnimation];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SamLive *live = self.dataList[indexPath.row];
    SamPlayerViewController *playerVC = [[SamPlayerViewController alloc]init];
    playerVC.dataList = self.dataList;
    playerVC.live = live;
    playerVC.index = indexPath.row;
    
    [playerVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:playerVC animated:YES completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        ((SamNearbyHeaderView *)headerView).delegate = self;
        [((SamNearbyHeaderView *)headerView).filterGender setTitle:self.titles[_genderIndex] forState:UIControlStateNormal];
        reusableView = headerView;

    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        reusableView = headerView;
    }
    return reusableView;
}

- (UICollectionReusableView *)prepareForHeaderView:(UICollectionReusableView *)headView {
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nearby_icon_now_live"]];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(headView.mas_left).with.offset(8);
        make.height.equalTo(@(imageView.bounds.size.height));

    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"正在直播";
    title.textColor = [UIColor cyanColor];
    title.font = [UIFont systemFontOfSize:14];
    [headView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.height.equalTo(imageView.mas_height);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.width.greaterThanOrEqualTo(@50);
    }];
    UIButton *filterGender = [[UIButton alloc]init];
    [filterGender setTitle:@"只看女" forState:UIControlStateNormal];
    [filterGender setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    filterGender.titleLabel.font = [UIFont systemFontOfSize:14];
    [filterGender addTarget:self action:@selector(clickFilterGender:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:filterGender];
    [filterGender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.height.equalTo(@30);
        make.right.equalTo(headView.mas_right).with.offset(-16);
        make.width.greaterThanOrEqualTo(@50);
    }];
    NSLog(@"current title: %@",filterGender.currentTitle);
    return headView;
}

- (void)clickFilterGender: (UIButton *)button {
}

-(void)headerView:(SamNearbyHeaderView *)headerView clickFilterGender:(UIButton *)button
{
    UIAlertController *alertSheetViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *seeAllAction = [UIAlertAction actionWithTitle:@"看全部" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadData];
        self.genderIndex = 0;
        [button setTitle:self.titles[_genderIndex] forState:UIControlStateNormal];
    }];
    [seeAllAction setValue:[UIColor colorWithHexString:@"00FFCC"] forKey:@"titleTextColor"];
    UIAlertAction *seeGirlsAction = [UIAlertAction actionWithTitle:@"只看女" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadData];
        self.genderIndex = 1;
        [button setTitle:self.titles[_genderIndex] forState:UIControlStateNormal];
    }];
    [seeGirlsAction setValue:[UIColor colorWithHexString:@"FF33FF"] forKey:@"titleTextColor"];
    UIAlertAction *seeBoysAction = [UIAlertAction actionWithTitle:@"只看男" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadData];
        self.genderIndex = 2;
        [button setTitle:self.titles[_genderIndex] forState:UIControlStateNormal];
    }];
    [seeBoysAction setValue:[UIColor colorWithHexString:@"3366FF"] forKey:@"titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [cancelAction setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"_titleTextColor"];

    [alertSheetViewController addAction:seeAllAction];
    [alertSheetViewController addAction:seeGirlsAction];
    [alertSheetViewController addAction:seeBoysAction];
    [alertSheetViewController addAction:cancelAction];
    [self presentViewController:alertSheetViewController animated:YES completion:nil];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={[UIScreen mainScreen].bounds.size.width,45};
    return size;
}

#pragma mark ScrollView Delegate

// Hide or show bars when moved
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //get scrollView's PanGesture
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //get velocity >0 pull down <0 move up
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity <- 5) {
        //move up hide bars
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.tabBarController.tabBar.hidden = YES;
    }else if (velocity > 5) {
        //pull down show bars
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.tabBarController.tabBar.hidden = NO;
    }else if(velocity == 0){
        //stop...
    }
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
