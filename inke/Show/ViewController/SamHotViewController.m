//
//  SamHotViewController.m
//  inke
//
//  Created by Sam on 12/2/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamHotViewController.h"
#import "SamLiveHandler.h"
#import "SamLiveCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SamPlayerViewController.h"
#import "SamTabBarViewController.h"

static NSString *identifier = @"SamLiveCell";

@interface SamHotViewController ()

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SamHotViewController

-(NSMutableArray *)dataList
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void) initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SamLiveCell" bundle:nil] forCellReuseIdentifier:identifier] ;
    
}

-(void) loadData
{
    [SamLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
       // NSLog(@"%@",obj);
        [self.dataList addObjectsFromArray:obj];
        [self.tableView reloadData];
    } failed:^(id obj) {
        
        NSLog(@"%@",obj);
        
    }];
}

#pragma mark TableView staff



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
    //return 1;
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
