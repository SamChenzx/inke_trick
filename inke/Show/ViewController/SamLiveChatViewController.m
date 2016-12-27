//
//  SamLiveChatViewController.m
//  inke
//
//  Created by Sam on 12/12/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLiveChatViewController.h"
#import "HttpTool.h"


@interface SamLiveChatViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIButton *votesButton;
@property (weak, nonatomic) IBOutlet UILabel *onLineUserLabel;


@end

@implementation SamLiveChatViewController

-(void)setLive:(SamLive *)live
{
    _live = live;
    [self.iconView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_HOST,_live.creator.portrait] placeholder:@"default_room"];
    self.iconView.layer.cornerRadius = 15;
    self.iconView.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer)
    {
//        [HttpTool getWithPath:API_HOT_LIVE params:nil success:^(id json) {
//            if ([json[@"dm_error"]integerValue]) {
//                failed(json[@"error_msg"]);
//            } else {
//                // get correct data
//                NSArray *lives = [SamLive mj_objectArrayWithKeyValuesArray:json[@"lives"]];
//                success(lives);
//            }
//        } failure:^(NSError *error) {
//            
//            failed(error);
//        }];
        
        self.onLineUserLabel.text = [NSString stringWithFormat:@"%ld", (long)self.live.onlineUsers];
        [self.votesButton setTitle:[NSString stringWithFormat:@"映票:%d",10000+arc4random_uniform(100)] forState:UIControlStateNormal];
        [self.votesButton.titleLabel sizeToFit];
    } repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
