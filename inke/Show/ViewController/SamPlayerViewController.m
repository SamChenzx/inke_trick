//
//  SamPlayerViewController.m
//  inke
//
//  Created by Sam on 12/8/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamPlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "SamLiveChatViewController.h"
#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "SamPlayerScrollView.h"

@interface SamPlayerViewController () <SamPlayerScrollViewDelegate>

@property(atomic, retain) id<IJKMediaPlayback> player;
@property(nonatomic, strong) UIButton * closeButton;
@property(nonatomic, strong) SamLiveChatViewController *liveChatVC;
@property(nonatomic, strong) SamPlayerScrollView * playerScrollView;

@end

@implementation SamPlayerViewController

-(SamLiveChatViewController *)liveChatVC
{
    if (!_liveChatVC) {
        _liveChatVC = [[SamLiveChatViewController alloc]init];
    }
    return _liveChatVC;
}

- (SamPlayerScrollView *)playerScrollView
{
    if (!_playerScrollView) {
        _playerScrollView = [[SamPlayerScrollView alloc] initWithFrame:self.view.frame];
        _playerScrollView.playerDelegate = self;
        _playerScrollView.index = self.index;
    }
    return _playerScrollView;
}

-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
        [_closeButton sizeToFit];
        _closeButton.frame = CGRectMake(self.view.bounds.size.width-_closeButton.bounds.size.width-8, self.view.bounds.size.height-_closeButton.bounds.size.height-8, _closeButton.bounds.size.width, _closeButton.bounds.size.height);
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(void) closeAction: (UIButton *) button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initPlayer];
//    [self addChildVC];
}

-(void) initPlayer
{
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:self.live.streamAddr withOptions:options];
    self.player = player;
    self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.playerScrollView addSubview:self.player.view];
    [self addLiveChatViewToView:self.playerScrollView WithLive:self.live];
}

- (void)reloadPlayerWithLive:(SamLive *)live
{
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    [self.player.view removeFromSuperview];
    [self.liveChatVC.view removeFromSuperview];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:live.streamAddr withOptions:options];
    self.player = player;
    self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.player.shouldAutoplay = YES;
    // register live's notification
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
    [self.playerScrollView addSubview:self.player.view];
    [self addLiveChatViewToView:self.playerScrollView WithLive:live];
}

-(void) initUI
{
    [self.playerScrollView updateForLives:self.dataList withCurrentIndex:self.index];
    self.playerScrollView.playerDelegate = self;
    [self.view addSubview:self.playerScrollView];
}

-(void) addLiveChatViewToView:(UIView *)view WithLive: (SamLive *)live
{
    [self addChildViewController:self.liveChatVC];
    self.liveChatVC.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    [view addSubview:self.liveChatVC.view];
    self.liveChatVC.live = live;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // register live's notification
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
    
    UIWindow *w = [[UIApplication sharedApplication].delegate window];
    [w addSubview:self.closeButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    // shutdown
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    [self.closeButton removeFromSuperview];
}

#pragma mark PlayerScrollViewDelegate

- (void)playerScrollView:(SamPlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index
{
    NSLog(@"current index from delegate:%ld  %s",(long)index,__FUNCTION__);
    if (self.index == index) {
        return;
    } else {
        [self reloadPlayerWithLive:self.dataList[index]];
        self.index = index;
    }
}



#pragma mark player staff

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
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
