//
//  LessonPlayerViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerViewController.h"
#import "ZFPlayer.h"
#import "playerConfigure.h"
#import "XJAccountManager.h"
#import "SettingViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "XMShareView.h"
static CGFloat videoBottomViewH = 49;
static CGFloat titleH = 35;
static CGFloat selViewH = 3;


@interface LessonPlayerViewController () <UIScrollViewDelegate, LessonPlayerVideoBottomViewDelegate,
        LessonPlayerLessonListViewControllerDelegate,
        UIAlertViewDelegate>
@property (nonatomic, strong) UIView *playView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) LessonPlayerVideoBottomView *videoBottomView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
/// 选中按钮
@property (nonatomic, strong) UIButton *selTitleButton;
///展示按钮下View
@property (nonatomic, strong) UIView *selView;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) LessonDetailListModel *tempLessonDetailModel;
@property (nonatomic, strong) LessonPlayerLessonListViewController *lessonPlayerLessonListViewController;
@property (nonatomic, strong) XMShareView *shareView;
@property (nonatomic, strong) UIView *backGroudView;
@end

@implementation LessonPlayerViewController


- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //若3G/4G 提示打开开关
    if ([UserDefaultObjectForKey(USER_SETTING_WIFI) isEqualToString:@"NO"]
            && [AFNetworkReachabilityManager sharedManager].reachableViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前为3G/4G网络,请去设置中打开,才可以观看视频"
                                                       delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    } else if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self requestLessonListData:[NSString stringWithFormat:@"%@/%@",coursesProjectLessonDetailList, self.lesssonID] method:GET];
    [self sendPlayerHistoryToServerData:history method:POST];

}

- (void)requestLessonListData:(APIName *)api method:(RequestMethod)method {

    if (method == GET) {
        __weak typeof(self) wSelf = self;
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            __strong typeof(self) sSelf = wSelf;
            sSelf.tempLessonDetailModel = [[LessonDetailListModel alloc]
                    initWithData:responseData error:nil];
            for (TalkGridModel *model in sSelf.tempLessonDetailModel.result.lessons_menu) {
                if ([model.type isEqualToString:@"dir"]) {
                    for (TalkGridModel *dirModel in model.children) {
                        if ([dirModel.id_ isEqualToString:self.playTalkGridModel.id_]) {
                            sSelf.playTalkGridModel = dirModel;
                        }
                    }
                } else if ([model.type isEqualToString:@"lesson"]) {
                    if ([model.id_ isEqualToString:self.playTalkGridModel.id_]) {
                        sSelf.playTalkGridModel = model;
                    }
                }
            }
            sSelf.videoBottomView.model = sSelf.playTalkGridModel;
            sSelf.videoBottomView.collectionCount.text = sSelf.tempLessonDetailModel.result.likes_count;
            if (sSelf.tempLessonDetailModel.result.user_liked) {
                [sSelf.videoBottomView.collectionLogo                              setImage:[[UIImage imageNamed:@"iconLikeOn"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            } else {
                [sSelf.videoBottomView.collectionLogo                              setImage:[[UIImage imageNamed:@"iconLike"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
            sSelf.lessonPlayerLessonListViewController.lessonDetailListModel = sSelf.tempLessonDetailModel;
            sSelf.lessonPlayerLessonListViewController.selectedModel = sSelf.playTalkGridModel;
            if (sSelf.tempLessonDetailModel.result.user_purchased || sSelf.tempLessonDetailModel.result.user_subscribed) {
                sSelf.lessonPlayerLessonListViewController.isPay = YES;
            }
            [sSelf.lessonPlayerLessonListViewController.tableView reloadData];

        } failedBlock:^(NSError *_Nullable error) {

        }];
    }
    if (method == POST) {
        [self PostOrDeleteRequestData:api Method:POST];
    }
    if (method == DELETE) {
        [self PostOrDeleteRequestData:api Method:DELETE];
    }

}

- (void)PostOrDeleteRequestData:(APIName *)api Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", self.playTalkGridModel.id_],
                    @"type" : [NSString stringWithFormat:@"%@", self.playTalkGridModel.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.playTalkGridModel.department]}];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", coursesProjectLessonDetailList, self.lesssonID] method:GET];
        
    } failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

///给服务器发送POST PlayerHistory
- (void)sendPlayerHistoryToServerData:(APIName *)api method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.id],
                    @"type" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.department],
                    @"duration" : @"1"}];

    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {

    }failedBlock:^(NSError *_Nullable error) {

    }];
}

///发送点赞，和取消点赞
- (void)PraiseAction:(APIName *)api Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.id],
                    @"type" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.lessonDetailListModel.result.department]}];
    if (method == POST) {
        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", coursesProjectLessonDetailList, self.lesssonID] method:GET];
        }failedBlock:^(NSError *_Nullable error) {
        }];
    } else if (method == DELETE) {
        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", coursesProjectLessonDetailList, self.lesssonID] method:GET];
        }failedBlock:^(NSError *_Nullable error) {
        }];
    }
}


#pragma mark- mainUI

- (void)initMainUI {
    [self initPlayerView];
    [self setBackGroudView];
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
    [self setSharView];
}
- (void)setSharView
{
    self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds
                                                   type:@"分享"];
    [self.view addSubview:_shareView];
    _shareView.hidden = YES;
}


#pragma mark PlayerView

- (void)initPlayerView {
    if (_playView) {
        [_playView removeFromSuperview];
        _playView = nil;
    }
    self.playView = [[UIView alloc] init];
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

    self.playerView = [ZFPlayerView sharedPlayerView];
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
    if (self.lessonDetailListModel.result.cover && self.lessonDetailListModel.result.cover.count > 0) {
        LessonDetailListCover *tempCover =  self.lessonDetailListModel.result.cover.firstObject;
        _playerView.xjfloading_image = [UIImage imageWithData:
                                        [NSData dataWithContentsOfURL:[NSURL URLWithString:tempCover.url]]];
    }
 
}

- (void)setBackGroudView
{
    self.backGroudView = [[UIView alloc] init];
    [self.view addSubview:self.backGroudView];
    [self.backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.backGroudView.backgroundColor = [UIColor clearColor];
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
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

#pragma mark - setVideoBottomView

- (void)setVideoBottomView {
    self.videoBottomView = [[LessonPlayerVideoBottomView alloc]
            initWithFrame:CGRectMake(0, 0, SCREENWITH, videoBottomViewH)];
    self.videoBottomView.backgroundColor = [UIColor whiteColor];
    [self.backGroudView addSubview:self.videoBottomView];
    self.videoBottomView.delegate = self;
}

#pragma mark 分享 - 收藏 - 点赞

- (void)LessonPlayerVideoBottomView:(LessonPlayerVideoBottomView *)sender
      DidDownloadOrCollectionButton:(UIButton *)button {
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    }
    {
        //收藏
        if (button.tag == 101) {

            if (self.playTalkGridModel.user_favored) {
                [self requestLessonListData:favorite method:DELETE];
            } else if (!self.playTalkGridModel.user_favored) {
                [self requestLessonListData:favorite method:POST];
            }
        }
            //分享
        else if (button.tag == 102) {
            _shareView.shareTitle = self.playTalkGridModel.title;
            _shareView.shareText = self.playTalkGridModel.content;
            _shareView.shareUrl = self.playUrl;
            if (self.playTalkGridModel.cover && self.playTalkGridModel.cover.count > 0) {
                TalkGridCover *tempCover = self.playTalkGridModel.cover.firstObject;
              _shareView.shareImage = tempCover.url;
            }
            _shareView.hidden = _shareView.hidden ? NO : YES;
        }
            //点赞
        else if (button.tag == 103) {
            //已点赞，进行取消点赞
            if (self.tempLessonDetailModel.result.user_liked) {
                [self PraiseAction:praise Method:DELETE];
                //未点赞，进行点赞
            } else {
                [self PraiseAction:praise Method:POST];
            }
        }
    }

}

#pragma mark - 设置头部标题栏

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.videoBottomView.frame) + 1, SCREENWITH, titleH);

    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.backGroudView addSubview:titleScrollView];

    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容

- (void)setupContentScrollView {
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH);

    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.backGroudView addSubview:contentScrollView];

    self.contentScrollView = contentScrollView;
    self.contentScrollView.bounces = NO;
}

#pragma mark - 添加子控制器

- (void)addChildViewController {

    self.lessonPlayerLessonListViewController = [[LessonPlayerLessonListViewController alloc] init];
    self.lessonPlayerLessonListViewController.title = @"目录";
    [self addChildViewController:self.lessonPlayerLessonListViewController];
    self.lessonPlayerLessonListViewController.delegate = self;
    __weak LessonPlayerViewController *tempSelf = self;

    ///选择Cell 切换播放Model
    self.lessonPlayerLessonListViewController.actionWithDidSelectedBlock = ^(TalkGridModel *model) {
        tempSelf.playTalkGridModel = model;
        //视频换URL
        [tempSelf.playerView pause];
        if (model.video_player.count > 0) {
            [tempSelf.playerView pause];
            [tempSelf.playerView resetToPlayNewURL];
            TalkGridVideo *gridVideomodel = tempSelf.playTalkGridModel.video_player.firstObject;
            tempSelf.playUrl = gridVideomodel.url;
            tempSelf.playerView.videoURL = [NSURL URLWithString:tempSelf.playUrl];
            if (tempSelf.playTalkGridModel.cover && tempSelf.playTalkGridModel.cover.count > 0) {
                TalkGridCover *tempCover = tempSelf.playTalkGridModel.cover.firstObject;
                tempSelf.playerView.xjfloading_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                               [NSURL URLWithString:tempCover.url]]];
            }
            [tempSelf.playerView play];
        }
        //视频是否收藏过
        if (tempSelf.playTalkGridModel.user_favored) {
            [tempSelf.videoBottomView.collection                               setImage:[[UIImage imageNamed:@"iconFavoritesOn"]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        } else {
            [tempSelf.videoBottomView.collection setImage:[UIImage imageNamed:@"iconFavorites"]
                                                 forState:UIControlStateNormal];
        }
    };

    LessonPlayerLessonDescribeViewController *vc1 = [[LessonPlayerLessonDescribeViewController alloc] init];
    vc1.contentText = self.lessonDetailListModel.result.content;
    vc1.title = @"课程介绍";
    [self addChildViewController:vc1];

//    LessonPlayerLessonCommentsViewController *vc2 = [[LessonPlayerLessonCommentsViewController alloc] init];
//    vc2.title = @"推荐课程";
//    [self addChildViewController:vc2];

    LessonPlayerLessonRecommendedViewController *vc3 = [[LessonPlayerLessonRecommendedViewController alloc] init];
    vc3.title = @"评论";
    vc3.ID = self.lesssonID;
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
    [self.backGroudView addSubview:self.selBackGroundView];

    //
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selBackGroundView.frame.origin.y, w, selViewH)];
    self.selView.backgroundColor = BlueColor
    [self.backGroudView addSubview:self.selView];
    @weakify(self)
    [RACObserve(self.contentScrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self)
        CGPoint offSet = [x CGPointValue];
        CGFloat percent = offSet.x/SCREENWITH;
        [self.selView setFrame:CGRectMake(percent*SCREENWITH/count, CGRectGetMaxY(self.titleScrollView.frame), SCREENWITH/count, selViewH)];
    }];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.selView.center = CGPointMake(btn.center.x, self.selBackGroundView.center.y);
    }];
}

- (void)setUpOneChildViewController:(NSUInteger)i {
    CGFloat x = i * SCREENWITH;

    UIViewController *vc = self.childViewControllers[i];

    if (vc.view.superview) {
        return;
    }
    CGFloat tempHeight = ScreenWidth * 9 / 16;
    vc.view.frame = CGRectMake(x, 0, SCREENWITH, SCREENHEIGHT - tempHeight - 20 - videoBottomViewH - titleH - selViewH);

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark -lessonPlayerLessonListViewControllerDelegate

- (void)lessonPlayerLessonListViewController:(LessonPlayerLessonListViewController *)vc
                      TableDidSelectedAction:(TalkGridModel *)selectModel {
    [self sendUserLearendMessage:user_learnedApi Method:POST ByModel:selectModel];
}

- (void)sendUserLearendMessage:(APIName *)api Method:(RequestMethod)method ByModel:(TalkGridModel *)model {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", model.id_],
                    @"type" : [NSString stringWithFormat:@"%@", model.type],
                    @"department" : [NSString stringWithFormat:@"%@", model.department],
                    @"status" : @"1"}];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", coursesProjectLessonDetailList, self.lesssonID] method:GET];
    }failedBlock:^(NSError *_Nullable error) {

    }];
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
