//
//  SamContributionViewController.m
//  inke
//
//  Created by Sam on 12/23/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamContributionViewController.h"
#import "SamLiveHandler.h"
#import "SamTickerActionsViewController.h"

@interface SamContributionViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *privateNavigationItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *privateNavigationBar;


@end

@implementation SamContributionViewController

#pragma mark - SamtickersDelegate

-(void) initUI
{
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.privateNavigationItem.leftBarButtonItem = leftItem;
    self.privateNavigationItem.title = @"映票贡献榜";
    [self.privateNavigationBar setTitleTextAttributes:attributes];
    [self.privateNavigationBar setTintColor:[UIColor whiteColor]];
}

- (void)clickBack:(UIBarButtonItem *)item {
    NSLog(@"should go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

@end
