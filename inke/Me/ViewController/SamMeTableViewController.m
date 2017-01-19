//
//  SamMeTableViewController.m
//  inke
//
//  Created by Sam on 12/22/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamMeTableViewController.h"
#import "SamMeInfoView.h"
#import "SamSetting.h"
#import "SamContributionViewController.h"
#import "SamShortVideosViewController.h"

#define tableHeaderViewHeight 363

@interface SamMeTableViewController ()

@property(nonatomic, strong) NSArray * dataList;
@property(nonatomic, strong) SamMeInfoView * infoView;

@property (nonatomic, strong) UIView *header;




@end

@implementation SamMeTableViewController


-(SamMeInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [SamMeInfoView loadInfoView];
        _infoView.headImageView.layer.cornerRadius = 30;
        _infoView.headImageView.layer.masksToBounds = YES;
        _infoView.contentMode = UIViewContentModeScaleToFill;
        _infoView.clipsToBounds = YES;
    }
    return _infoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.rowHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, tableHeaderViewHeight)];
    [_header addSubview:self.infoView];
    self.tableView.tableHeaderView = _header;
    
    [self loadData];
}

- (void)loadData
{
    SamSetting *setting1 = [[SamSetting alloc]init];
    setting1.title = @"映票贡献榜";
    setting1.subTitle = @"";
    setting1.vcName = @"SamContributionViewController";
    
    SamSetting *setting2 = [[SamSetting alloc]init];
    setting2.title = @"短视频";
    setting2.subTitle = @"";
    setting2.vcName = @"SamShortVideosViewController";
    
    SamSetting *setting3 = [[SamSetting alloc]init];
    setting3.title = @"收益";
    setting3.subTitle = @"0 映票";
    setting3.vcName = @"SamIncomeViewController";
    
    SamSetting *setting4 = [[SamSetting alloc]init];
    setting4.title = @"账户";
    setting4.subTitle = @"0 钻石";
    setting4.vcName = @"SamAccountViewController";
    
    SamSetting *setting5 = [[SamSetting alloc]init];
    setting5.title = @"等级";
    setting5.subTitle = @"3级";
    setting5.vcName = @"SamLevelViewController";
    
    SamSetting *setting6 = [[SamSetting alloc]init];
    setting6.title = @"实名认证";
    setting6.subTitle = @"";
    setting6.vcName = @"SamCertificationViewController";
    
    SamSetting *setting7 = [[SamSetting alloc]init];
    setting7.title = @"设置";
    setting7.subTitle = @"";
    setting7.vcName = @"SamSettingViewController";
    
    NSArray *array1 = @[setting1,setting2,setting3,setting4];
    NSArray *array2 = @[setting5,setting6];
    NSArray *array3 = @[setting7];
                        
    self.dataList = @[array1,array2,array3];
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

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataList[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Configure the cell...
    SamSetting *setting = self.dataList[indexPath.section][indexPath.row];
    cell.textLabel.text = setting.title;
    cell.detailTextLabel.text = setting.subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SamSetting *setting = self.dataList[indexPath.section][indexPath.row];
    if ([setting.vcName isEqualToString:(NSStringFromClass([SamContributionViewController class]))]) {
        SamContributionViewController *detailViewController = [[SamContributionViewController alloc] initWithNibName:@"SamContributionViewController" bundle:nil];
        // Pass the selected object to the new view controller.
        
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
//        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
        return;
    } else if ([setting.vcName isEqualToString:(NSStringFromClass([SamShortVideosViewController class]))]){
        
        SamShortVideosViewController *detailViewController = [[SamShortVideosViewController alloc]init];
        detailViewController.urlString = @"https://www.baidu.com";
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        return;
    } else {
    return ;
    }
}

#pragma mark - Scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat Offset_y = scrollView.contentOffset.y;

    if ( Offset_y < 0) {
        // the hight after pull down
        CGFloat totalOffset = tableHeaderViewHeight - Offset_y;
        // set frame
        _infoView.frame = CGRectMake(0, Offset_y, kScreenWidth, totalOffset);
    }
}




@end
