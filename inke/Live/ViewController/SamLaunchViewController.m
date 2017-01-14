//
//  SamLaunchViewController.m
//  inke
//
//  Created by Sam on 12/2/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLaunchViewController.h"
#import "LFLivePreview.h"

@interface SamLaunchViewController () 

@property (nonatomic, strong) LFLivePreview * preview;
@property (nonatomic, strong) UITextField * titleTextField;
@property (nonatomic, strong) UIButton * startLiveButton;

@end

@implementation SamLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)closeKeyBoard: (UIGestureRecognizer *)tap
{
    [self.titleTextField resignFirstResponder];
}

- (void)initUI
{
    self.preview = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    self.preview.vc = self;
    [self.view addSubview:self.preview];
    self.titleTextField = [[UITextField alloc] init];
    UIColor *color = [UIColor whiteColor];
    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"给直播写个标题吧" attributes:@{NSForegroundColorAttributeName:color}];
    self.titleTextField.font = [UIFont systemFontOfSize:25];
    self.titleTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
        make.width.mas_greaterThanOrEqualTo(200);
        make.height.mas_greaterThanOrEqualTo(40);
        
    }];
    
    self.startLiveButton = [[UIButton alloc]init];
    [self.startLiveButton setBackgroundImage:[UIImage imageNamed:@"live_button_h"] forState:UIControlStateNormal];
    [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
    self.startLiveButton.titleLabel.font = [UIFont systemFontOfSize:23];
    self.startLiveButton.titleLabel.textColor = [UIColor whiteColor];
    [self.startLiveButton addTarget:self action:@selector(clickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startLiveButton];
    [self.startLiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(30);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);

    }];
}

- (void)clickStartButton: (UIButton *)button
{
        // start live
    [self.preview startLive];
    [self.titleTextField resignFirstResponder];
    self.titleTextField.hidden = YES;
    self.startLiveButton.hidden = YES;
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
