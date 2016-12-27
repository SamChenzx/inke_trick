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

static NSString *identifier = @"SamNearbyLiveCell";

#define kMargin 5
#define kItemWidth 100


@interface SamNearbyViewController() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation SamNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [self loadData];
    
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
//    [self.collectionView registerClass:[SamNearbyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

- (void)loadData
{
    [SamLiveHandler executeGetNearbyLiveTaskWithSuccess:^(id obj) {
        NSLog(@"%@",obj);
        self.dataList = obj;
        [self.collectionView reloadData];
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

    playerVC.live = live;
    
    [playerVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:playerVC animated:YES completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        reusableView = headerView;
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        // reusableView = [self prepareForHeaderView:headerView];
        reusableView = headerView;
    }
    
    return reusableView;
}

- (UICollectionReusableView *)prepareForHeaderView:(UICollectionReusableView *)headView
{
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
    [filterGender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    filterGender.titleLabel.font = [UIFont systemFontOfSize:14];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={[UIScreen mainScreen].bounds.size.width,45};
    return size;
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
