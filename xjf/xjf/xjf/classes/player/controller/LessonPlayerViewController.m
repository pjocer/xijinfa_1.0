//
//  LessonPlayerViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFPlayer.h"
#import "playerConfigure.h"
#import "LessonDetailLessonListViewController.h"
static CGFloat videoBottomViewH = 49;
static CGFloat titleH = 35;
static CGFloat selViewH = 3;


@interface LessonPlayerViewController () <UIScrollViewDelegate>
@property(nonatomic, strong) UIView *playView;
@property(strong, nonatomic) ZFPlayerView *playerView;

@property(nonatomic, strong) LessonPlayerVideoBottomView *videoBottomView;

@property(nonatomic, weak) UIScrollView *titleScrollView;
@property(nonatomic, weak) UIScrollView *contentScrollView;
/// 选中按钮
@property(nonatomic, weak) UIButton *selTitleButton;
///展示按钮下View
@property(nonatomic, strong) UIView *selView;
@property(nonatomic, strong) UIView *selBackGroundView;
@property(nonatomic, strong) NSMutableArray *buttons;
@end

@implementation LessonPlayerViewController


- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

#pragma mark- mainUI

- (void)initMainUI {
    [self initPlayerView];
    [self setVideoBottomView];
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
    [self setupTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWITH, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;

}

#pragma mark PlayerView

- (void)initPlayerView {
    if (_playView) {
        [_playView removeFromSuperview];
        _playView = nil;
    }
    _playView = [[UIView alloc] init];
    _playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];


//    self.playUrl = @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4";
    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }

    _playerView = [ZFPlayerView sharedPlayerView];
    [self.view addSubview:_playerView];

    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];

    _playerView.backgroundColor = [UIColor blackColor];
    __weak typeof(self) weakSelf = self;
    _playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    _playerView.videoURL = [NSURL URLWithString:self.playUrl];

}

#pragma mark 横竖屏状态

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = BackgroundColor;
        self.videoBottomView.hidden = NO;
        self.titleScrollView.hidden = NO;
        self.contentScrollView.hidden = NO;
        self.selBackGroundView.hidden = NO;
        self.selView.hidden = NO;
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        self.videoBottomView.hidden = YES;
        self.titleScrollView.hidden = YES;
        self.contentScrollView.hidden = YES;
        self.selBackGroundView.hidden = YES;
        self.selView.hidden = YES;
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }

}

#pragma mark - setVideoBottomView

- (void)setVideoBottomView {
    self.videoBottomView = [[LessonPlayerVideoBottomView alloc]
            initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), SCREENWITH, videoBottomViewH)];
    self.videoBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoBottomView];

}


#pragma mark - 设置头部标题栏

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.videoBottomView.frame) + 1, SCREENWITH, titleH);

    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];

    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容

- (void)setupContentScrollView {
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH);

    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:contentScrollView];

    self.contentScrollView = contentScrollView;
    self.contentScrollView.bounces = NO;
}

#pragma mark - 添加子控制器

- (void)addChildViewController {
//    #import "LessonDetailLessonListViewController.h" //一样的
    LessonPlayerLessonListViewController *vc = [[LessonPlayerLessonListViewController alloc] init];
    vc.title = @"目录";
    [self addChildViewController:vc];

    LessonPlayerLessonDescribeViewController *vc1 = [[LessonPlayerLessonDescribeViewController alloc] init];
    vc1.title = @"课程介绍";
    [self addChildViewController:vc1];

    LessonPlayerLessonCommentsViewController *vc2 = [[LessonPlayerLessonCommentsViewController alloc] init];
    vc2.title = @"推荐课程";
    [self addChildViewController:vc2];

    LessonPlayerLessonRecommendedViewController *vc3 = [[LessonPlayerLessonRecommendedViewController alloc] init];
    vc3.title = @"评论";
    [self addChildViewController:vc3];

}

#pragma mark - 设置标题

- (void)setupTitle {
    NSUInteger count = self.childViewControllers.count;

    CGFloat x = 0;
    CGFloat w = SCREENWITH / count;
    CGFloat h = titleH;

    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];

        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];

        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT15;

        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];

        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];

        if (i == 0) {
            [self chick:btn];
        }

    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;

    self.selBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0,
            CGRectGetMaxY(self.titleScrollView.frame),
            SCREENWITH,
            selViewH)];
    self.selBackGroundView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.selBackGroundView];

    //
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), w, selViewH)];
    self.selView.backgroundColor = BlueColor
    [self.view addSubview:self.selView];
}

// 按钮点击
- (void)chick:(UIButton *)btn {
    [self selTitleBtn:btn];

    NSUInteger i = btn.tag;
    CGFloat x = i * SCREENWITH;

    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);

}

// 选中按钮
- (void)selTitleBtn:(UIButton *)btn {
    self.selView.center = CGPointMake(btn.center.x, CGRectGetMaxY(self.titleScrollView.frame) + 1);
}

- (void)setUpOneChildViewController:(NSUInteger)i {
    CGFloat x = i * SCREENWITH;

    UIViewController *vc = self.childViewControllers[i];

    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, SCREENWITH, SCREENHEIGHT - self.contentScrollView.frame.origin.y);

    [self.contentScrollView addSubview:vc.view];

}

- (void)setupTitleCenter:(UIButton *)btn {
    CGFloat offset = btn.center.x - SCREENWITH * 0.5;
    //    NSLog(@"center.x:%lf   offset:%lf",btn.center.x,offset);

    if (offset < 0) {
        offset = 0;
    }

    CGFloat maxOffset = self.titleScrollView.contentSize.width - SCREENWITH;
    //    NSLog(@"maxOffset:%lf",maxOffset);
    if (offset > maxOffset) {
        offset = maxOffset;
    }

    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];


}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.contentScrollView.contentOffset.x / SCREENWITH;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


#pragma mark- dealloc

- (void)dealloc {
    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView pause];
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    if (_playView) {
        [_playView removeFromSuperview];
        _playView = nil;
    }
    NSLog(@"%@释放了", self.class);
}
@end
