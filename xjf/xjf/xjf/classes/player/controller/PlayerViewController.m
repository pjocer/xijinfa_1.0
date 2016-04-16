//
//  PlayerViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "ZFPlayerSingleton.h"
@interface PlayerViewController ()
{
    
}
@property(nonatomic,strong)UIView *playView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@end

@implementation PlayerViewController
@synthesize playUrl=_playUrl;
@synthesize playView=_playView;
@synthesize playerView = _playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    [[ZFHttpManager shared] registerNetworkStatusMoniterEvent];
    [self initMainUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.playerView.frame =CGRectMake(0, 20, SCREENHEIGHT, 211);
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor clearColor];
        self.playerView.frame =CGRectMake(0, 0, SCREENHEIGHT,SCREENWITH);
    }
    NSLog(@"---%@",NSStringFromCGRect(self.playerView.frame));
}
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    return ![ZFPlayerSingleton sharedZFPlayer].isLockScreen;;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView=nil;
    }
    if (_playView) {
        [_playView removeFromSuperview];
        _playView=nil;
    }
    
    NSLog(@"%@释放了",self.class);
}

//mainUI
-(void)initMainUI
{
    if (_playView) {
        [_playView removeFromSuperview];
        _playView=nil;
    }
    _playView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 231)];
    _playView.backgroundColor =[UIColor blackColor];
    [self.view addSubview:_playView];
    self.playUrl = @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4";
   
    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView=nil;
    }
    _playerView = [ZFPlayerView sharedPlayerView];
    _playerView.frame =CGRectMake(0, 20, SCREENWITH, 211);
    _playerView.backgroundColor=[UIColor blackColor];
    __weak typeof(self) weakSelf = self;
    _playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _playerView.videoURL = [NSURL URLWithString:self.playUrl];
    [self.view addSubview:_playerView];
}
@end
