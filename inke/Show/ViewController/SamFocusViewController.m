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
#import "SamActivitiesView.h"

static NSString * identifier = @"focus";
static NSString * headerIdentifier = @"focusHeader";

@interface SamFocusViewController ()

@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) SamActivitiesView *activitiesView;

@end

@implementation SamFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self loadData];
}

-(SamActivitiesView *)activitiesView
{
    if (!_activitiesView) {
        _activitiesView = [SamActivitiesView loadActivitiesView];
    }
    return _activitiesView;
}

-(void) initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SamLiveCell" bundle:nil] forCellReuseIdentifier:identifier] ;
}

-(void) loadData
{
    SamLive *live = [[SamLive alloc]init];
    live.city = @"杭州";
    live.onlineUsers = 18999;
    live.streamAddr = LIVE_SAM;
    
    SamCreator *creator = [[SamCreator alloc]init];
    creator.nick = @"Sam";
    creator.portrait = @"Sam";
    live.creator = creator;
    
    self.dataList = @[live];
    [self.tableView reloadData];
}

#pragma mark TableView staff

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataList.count;
    return 1;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activitiesView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenHeight*0.3;
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
    
    
    /****
     // we can't use the default media player
     MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:live.streamAddr]];
     [self presentViewController:movieVC animated:YES completion:nil];
     ****/
    
    
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
