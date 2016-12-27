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

@interface SamMeTableViewController ()

@property(nonatomic, strong) NSArray * dataList;
@property(nonatomic, strong) SamMeInfoView * infoView;

@end

@implementation SamMeTableViewController


-(SamMeInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [SamMeInfoView loadInfoView];
        _infoView.headImageView.layer.cornerRadius = 30;
        _infoView.headImageView.layer.masksToBounds = YES;
    }
    return _infoView;
}

//-(NSMutableArray *)dataList
//{
//    if (!_dataList) {
//        _dataList = [NSMutableArray array];
//    }
//    return _dataList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    
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
    setting2.vcName = @"SamSnapViewController";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.infoView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return [UIScreen mainScreen].bounds.size.height*0.45;
    }
    return 8;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
    } else {
        return;
    }
    
    
}



@end
