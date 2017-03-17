//
//  SamSettingViewController.m
//  inke
//
//  Created by Sam on 3/16/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//

#import "SamSettingViewController.h"
#import "SamSetting.h"

@interface SamSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) UINavigationItem *privateNavigationItem;
@property (nonatomic, strong) UINavigationBar *privateNavigationBar;

@end

@implementation SamSettingViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)loadData
{
    SamSetting *setting1 = [[SamSetting alloc]init];
    setting1.title = @"账号与安全";
    setting1.subTitle = @"";
    setting1.vcName = @"";
    
    SamSetting *setting2 = [[SamSetting alloc]init];
    setting2.title = @"黑名单";
    setting2.subTitle = @"";
    setting2.vcName = @"";
    
    SamSetting *setting3 = [[SamSetting alloc]init];
    setting3.title = @"开播提醒";
    setting3.subTitle = @"";
    setting3.vcName = @"";
    
    SamSetting *setting4 = [[SamSetting alloc]init];
    setting4.title = @"未关注人私信";
    setting4.subTitle = @"";
    setting4.vcName = @"";
    
    SamSetting *setting5 = [[SamSetting alloc]init];
    setting5.title = @"清理缓存";
    setting5.subTitle = @"";
    setting5.vcName = @"";
    
    SamSetting *setting6 = [[SamSetting alloc]init];
    setting6.title = @"帮助和反馈";
    setting6.subTitle = @"";
    setting6.vcName = @"";
    
    SamSetting *setting7 = [[SamSetting alloc]init];
    setting7.title = @"关于我们";
    setting7.subTitle = @"";
    setting7.vcName = @"";
    
    SamSetting *setting8 = [[SamSetting alloc]init];
    setting8.title = @"网络诊断";
    setting8.subTitle = @"";
    setting8.vcName = @"";
    
    NSArray *array1 = @[setting1];
    NSArray *array2 = @[setting2,setting3,setting4];
    NSArray *array3 = @[setting5];
    NSArray *array4 = @[setting6,setting7,setting8];
    
    self.dataList = @[array1,array2,array3,array4];
}


- (void)initUI {
    
    // table view
    self.tableView.rowHeight = 55;
    self.tableView.tableFooterView.height = 140;
    self.tableView.tableFooterView.width = kScreenWidth;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // navigationBar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.privateNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, kScreenWidth, 64)];
    [self.privateNavigationBar setTitleTextAttributes:attributes];
    [self.privateNavigationBar setTintColor:[UIColor whiteColor]];
    [self.privateNavigationBar setBarTintColor:[UIColor colorWithRed:36.0/255.0 green:215.0/255.0 blue:200.0/255.0 alpha:1]];
    self.privateNavigationItem = [[UINavigationItem alloc] initWithTitle:@"设置"];
    self.privateNavigationItem.leftBarButtonItem = leftItem;
    [self.privateNavigationBar setItems:@[self.privateNavigationItem]];
    [self.view addSubview:self.privateNavigationBar];
}

- (void)clickBack:(UIBarButtonItem *)item {
    NSLog(@"should go back");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clickLogOutButton:(UIButton *) button {
    
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
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.detailTextLabel.text = setting.subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([cell.textLabel.text isEqual: @"未关注人私信"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *messageSwitch = [[UISwitch alloc] init];
        [messageSwitch setOnTintColor:[UIColor colorWithRed:36.0/255.0 green:215.0/255.0 blue:200.0/255.0 alpha:1]];
        [messageSwitch setOn:YES];
        [cell addSubview:messageSwitch];
        [messageSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.textLabel.centerX);
            make.right.mas_equalTo(cell.right).offset(-8);
        }];
        
    }
    if ([cell.textLabel.text isEqual: @"清理缓存"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *cacheLabel = [[UILabel alloc]init];
        [cacheLabel setFont:[UIFont systemFontOfSize:13]];
        cacheLabel.text = @"438.42M";
        [cell addSubview:cacheLabel];
        [cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.textLabel.centerY);
            make.right.mas_equalTo(cell.right).offset(-8);
        }];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_dataList[indexPath.section][indexPath.row]  isEqual: @"清理缓存"]) {
        ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != _dataList.count-1) {
        return 5;
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _dataList.count-1) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        UIButton *logOutButton = [[UIButton alloc]init];
        NSDictionary *buttonAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSStrokeColorAttributeName:[UIColor colorWithRed:36.0/255.0 green:215.0/255.0 blue:200.0/255.0 alpha:1]};
        NSAttributedString *buttonTitle = [[NSAttributedString alloc]initWithString:@"退出登陆" attributes:buttonAttributes];
        [logOutButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
        [logOutButton setBackgroundImage:[UIImage imageNamed:@"me_button"] forState:UIControlStateNormal];
        [logOutButton addTarget:self action:@selector(clickLogOutButton:) forControlEvents:UIControlEventTouchUpInside];
        [logOutButton sizeToFit];
        [tableFooterView addSubview:logOutButton];
        [logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(tableFooterView.mas_centerX);
            make.centerY.mas_equalTo(tableFooterView.mas_centerY).mas_offset(40);
        }];
        
        UILabel *versionLabel = [[UILabel alloc]init];
        NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSStrokeColorAttributeName:[UIColor colorWithRed:36.0/255.0 green:215.0/255.0 blue:200.0/255.0 alpha:1]};
        NSAttributedString *labelTitle = [[NSAttributedString alloc]initWithString:@"Version 4.0.10" attributes:labelAttributes];
        [versionLabel setAttributedText:labelTitle];
        [tableFooterView addSubview:versionLabel];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(tableFooterView).centerOffset(CGPointMake(0, 75));
        }];
        [versionLabel setAttributedText:labelTitle];

        return tableFooterView;
    } else {
        return nil;
    }
}


@end
