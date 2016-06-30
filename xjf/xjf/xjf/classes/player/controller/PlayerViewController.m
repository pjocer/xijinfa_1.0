//
//  PlayerViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerViewController.h"
#import "playerConfigure.h"
#import "XJAccountManager.h"
#import <objc/runtime.h>
#import "CustomTextField.h"
#import "SettingViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "ZPlatformShare.h"

@interface PlayerViewController () <UICollectionViewDataSource,
        UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout,
        UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIView *playView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) BOOL isShowVideDescrible;
/**< 是否展示视频描述 */
@property (nonatomic, retain) UIView *keyBoardView;
/**< 键盘背景图 */
@property (nonatomic, retain) UIView *keyBoardAppearView;
/**< 键盘出现，屏幕背景图 */
@property (nonatomic, retain) CustomTextField *textField;
/**< 键盘 */
@property (nonatomic, strong) UIButton *sendMsgButton;
/**< 发表评论内容按钮 */
@property (nonatomic, strong) CommentsAllDataList *commentsModel;
/**< 评论数据 */
@property (nonatomic, strong) LessonDetailListModel *tempLessonDetailModel;
@property (nonatomic, strong) XMShareView *shareView;
@end

static NSString *PlayerVC_Describe_HeaderId = @"PlayerVC_Describe_HeaderId";
static NSString *PlayerVC_Describe_FooterId = @"PlayerVC_Describe_FooterId";
static NSString *PlayerVC_Recommended_HeaderId = @"PlayerVC_Recommended_HeaderId";
static NSString *PlayerVC_Comments_HeaderId = @"PlayerVC_Comments_HeaderId";
static NSString *PlayerVC_Comments_FooterId = @"PlayerVC_Comments_FooterId";
static NSString *PlayerVC_Describe_Cell_Id = @"PlayerVC_Describe_Cell_Id";
static NSString *PlayerVC_TalkGrid_Cell_Id = @"PlayerVC_TalkGrid_Cell_Id";
static NSString *PlayerVC_Comments_Cell_Id = @"PlayerVC_Comments_Cell_Id";


@implementation PlayerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowVideDescrible = NO; //默认不展示视频详情
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //若3G/4G 提示打开开关
    if ([UserDefaultObjectForKey(USER_SETTING_WIFI) isEqualToString:@"NO"]
            && [AFNetworkReachabilityManager sharedManager].reachableViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前为3G/4G网络,请去设置中打开,才可以观看视频"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self handleData];
}

- (void)handleData {
    [self requestCommentsData:[NSString stringWithFormat:@"%@%@/comments", talkGridcomments, self.talkGridModel.id_] method:GET];
    [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", talkGrid, self.talkGridModel.id_] method:GET];
    [self sendPlayerHistoryToServerData:history method:POST];
}

#pragma mark requestData

- (void)requestCommentsData:(APIName *)api method:(RequestMethod)method {

    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    //GET
    if (method == GET) {
        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            [[ZToastManager ShardInstance] hideprogress];
            self.commentsModel = [[CommentsAllDataList alloc] initWithData:responseData error:nil];
            [self.collectionView reloadData];
        }failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
    }
        //POST
    else if (method == POST) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.textField.text forKey:@"content"];
        [dic setValue:self.talkGridModel.id_ forKey:@"ID"];
        request.requestParams = dic;

        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            [self requestCommentsData:[NSString stringWithFormat:@"%@%@/comments",
                                       talkGridcomments, self.talkGridModel.id_]
                               method:GET];
        }failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];

    }


}

- (void)requestLessonListData:(APIName *)api method:(RequestMethod)method {

    if (method == GET) {
        __weak typeof(self) wSelf = self;
        [[ZToastManager ShardInstance] showprogress];
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            __strong typeof(self) sSelf = wSelf;
            sSelf.tempLessonDetailModel = [[LessonDetailListModel alloc] initWithData:responseData error:nil];
            [self.collectionView reloadData];
            [[ZToastManager ShardInstance] hideprogress];
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] hideprogress];
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
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
            @{@"id" : [NSString stringWithFormat:@"%@", self.tempLessonDetailModel.result.id],
                    @"type" : [NSString stringWithFormat:@"%@", self.tempLessonDetailModel.result.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.tempLessonDetailModel.result.department]}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", talkGrid, self.tempLessonDetailModel.result.id]
                             method:GET];
    }failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

- (void)sendPlayerHistoryToServerData:(APIName *)api method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", self.talkGridModel.id_],
                    @"type" : [NSString stringWithFormat:@"%@", self.talkGridModel.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.talkGridModel.department],
                    @"duration" : @"1"}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {

    }failedBlock:^(NSError *_Nullable error) {

    }];
}

///发送点赞，和取消点赞
- (void)PraiseAction:(APIName *)api Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", self.talkGridModel.id_],
                    @"type" : [NSString stringWithFormat:@"%@", self.talkGridModel.type],
                    @"department" : [NSString stringWithFormat:@"%@", self.talkGridModel.department]}];
    if (method == POST) {
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", talkGrid,
                     self.tempLessonDetailModel.result.id] method:GET];
        }failedBlock:^(NSError *_Nullable error) {
        }];
    } else if (method == DELETE) {
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [self requestLessonListData:[NSString stringWithFormat:
                                         @"%@/%@", talkGrid,
                                         self.tempLessonDetailModel.result.id] method:GET];
        }failedBlock:^(NSError *_Nullable error) {
        }];
    }
}

#pragma mark 横竖屏状态

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = BackgroundColor;
        self.collectionView.hidden = NO;
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        self.collectionView.hidden = YES;
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark- mainUI

- (void)initMainUI {
    [self initPlayerView];
    [self initCollectionView];
    [self initTextField];
    [self setSharView];
}

#pragma mark setSharView
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
    _playView = [[UIView alloc] init];
    _playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.playView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];

    //    self.playUrl = @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4";
    //    self.playUrl = @"http://api.dev.xijinfa.com/api/video-player/51197.m3u8";

    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    _playerView = [ZFPlayerView sharedPlayerView];
    _playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];

    __weak typeof(self) weakSelf = self;
    _playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    
    
//    TalkGridVideo *gridVideomodel = self.talkGridModel.video_player.firstObject;
//    self.playUrl = gridVideomodel.url;
//    TalkGridVideo *gridVideomodelLast = self.talkGridModel.video_player.lastObject;
//    _playerView.resolutionDic = @{@"xxx":self.playUrl,@"aaa":gridVideomodelLast.url};

    NSDictionary *dic = [NSMutableDictionary dictionary];
    for (TalkGridVideo *video in self.talkGridModel.video_player) {
        if ([video.resolution isEqualToString:@"auto"]) {
            self.playUrl = video.url;
        } else if ([video.resolution isEqualToString:@"nhd"]){
            [dic setValue:video.url forKey:@"标清"];
        } else if ([video.resolution isEqualToString:@"hd"]){
            [dic setValue:video.url forKey:@"高清"];
        } else if ([video.resolution isEqualToString:@"fhd"]){
            [dic setValue:video.url forKey:@"超清"];
        }
    }
    
    
    _playerView.resolutionDic = dic;
    _playerView.videoURL = [NSURL URLWithString:self.playUrl];
   
    
    [_playerView autoPlayTheVideo];
    
    if (self.talkGridModel.cover && self.talkGridModel.cover.count > 0) {
        TalkGridCover *tempCover = self.talkGridModel.cover.firstObject;
        _playerView.xjfloading_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                               [NSURL URLWithString:tempCover.url]]];
    }
  
}
#pragma mark CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0.0;
    _layout.minimumInteritemSpacing = 0.0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:_layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerClass:[PlayerPageDescribeCell class]
            forCellWithReuseIdentifier:PlayerVC_Describe_Cell_Id];
    [self.collectionView registerClass:[WikiTalkGridViewCell class]
            forCellWithReuseIdentifier:PlayerVC_TalkGrid_Cell_Id];
    [self.collectionView registerClass:[PlayerPageCommentsCell class]
            forCellWithReuseIdentifier:PlayerVC_Comments_Cell_Id];

    [self.collectionView registerClass:[PlayerPageDescribeHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:PlayerVC_Describe_HeaderId];
    [self.collectionView registerClass:[PlayerPageDescribeFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:PlayerVC_Describe_FooterId];

    [self.collectionView registerClass:[PlayerPageRecommendedHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:PlayerVC_Recommended_HeaderId];

    [self.collectionView registerClass:[PlayerPageCommentsHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:PlayerVC_Comments_HeaderId];
    [self.collectionView registerClass:[PlayerPageCommentsFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:PlayerVC_Comments_FooterId];


}

#pragma mark 键盘

/**键盘 */
- (void)initTextField {
    self.keyBoardAppearView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.keyBoardAppearView.backgroundColor = [UIColor blackColor];
    self.keyBoardAppearView.alpha = 0.2;
    [self.view addSubview:self.keyBoardAppearView];
    self.keyBoardAppearView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self action:@selector(keyBoardresignFirstResponder:)];
    [self.keyBoardAppearView addGestureRecognizer:tap];

    self.keyBoardView = [[UIView alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    self.keyBoardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.keyBoardView];

    self.textField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 10, SCREENWITH - 70, 30)];
    self.textField.backgroundColor = BackgroundColor
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 4;
    self.textField.placeholder = @"回复新内容";

    [self.textField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.keyBoardView addSubview:self.textField];
    self.textField.delegate = self;

    self.sendMsgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.keyBoardView addSubview:self.sendMsgButton];
    [self.sendMsgButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendMsgButton.titleLabel.font = FONT15;
    self.sendMsgButton.frame = CGRectMake(0, 0, 30, 19);
    self.sendMsgButton.center = CGPointMake(CGRectGetMaxX(self.textField.frame) + 30, self.textField.center.y);
    self.sendMsgButton.tintColor = [UIColor blackColor];
    [self.sendMsgButton addTarget:self action:@selector(sendCommentMsg:) forControlEvents:UIControlEventTouchUpInside];

    //UIKeyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardwillAppear:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark- CollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isShowVideDescrible) {
            return 1;
        }
        else if (!self.isShowVideDescrible) {
            return 0;
        }

    }
    else if (section == 1) {
        return self.talkGridListModel.result.data.count;
    }
    return self.commentsModel.result.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PlayerPageDescribeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Describe_Cell_Id
                                                                                 forIndexPath:indexPath];
        cell.model = self.talkGridModel;
        return cell;
    }
    else if (indexPath.section == 1) {
        WikiTalkGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_TalkGrid_Cell_Id
                                                                               forIndexPath:indexPath];
        cell.model = self.talkGridListModel.result.data[indexPath.row];
        return cell;
    }
    PlayerPageCommentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Comments_Cell_Id
                                                                             forIndexPath:indexPath];

    cell.commentsModel = self.commentsModel.result.data[indexPath.row];
    return cell;

}

/** Header And Footer */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {

            PlayerPageDescribeHeaderView *describeHeaderView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                       withReuseIdentifier:PlayerVC_Describe_HeaderId
                                                              forIndexPath:indexPath];
            describeHeaderView.model = self.tempLessonDetailModel.result;

            [describeHeaderView.rightButton addTarget:self action:@selector(describeHeaderViewRightButtonAction:)
                                     forControlEvents:UIControlEventTouchUpInside];
            if (_isShowVideDescrible == NO) {
                [describeHeaderView.rightButton                                    setImage:[[UIImage imageNamed:@"iconMore"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            } else if (_isShowVideDescrible == YES) {
                [describeHeaderView.rightButton                                    setImage:[[UIImage imageNamed:@"iconLess"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
//           [describeHeaderView.downLoadButton addTarget:self action:@selector(describeHeaderViewdownLoadButtonAction:)
// forControlEvents:UIControlEventTouchUpInside];
            [describeHeaderView.shareButton addTarget:self action:@selector(describeHeaderViewshareButtonAction:)
                                     forControlEvents:UIControlEventTouchUpInside];
            [describeHeaderView.collectionButton
                    addTarget:self action:@selector(describeHeaderViewcollectionButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            if (self.tempLessonDetailModel.result.user_favored) {
                [describeHeaderView.collectionButton                               setImage:[[UIImage imageNamed:@"iconFavoritesOn"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            } else {
                [describeHeaderView.collectionButton                               setImage:[[UIImage imageNamed:@"iconFavorites"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
            return describeHeaderView;
        }
        else if (indexPath.section == 1) {

            PlayerPageRecommendedHeaderView *recommendedHeaderView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                       withReuseIdentifier:PlayerVC_Recommended_HeaderId
                                                              forIndexPath:indexPath];
            return recommendedHeaderView;
        }
        else if (indexPath.section == 2) {

            PlayerPageCommentsHeaderView *CommentsHeaderView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
                                    PlayerVC_Comments_HeaderId
                                                              forIndexPath:indexPath];
            [CommentsHeaderView.commentsButton addTarget:self action:@selector(comments:)
                                        forControlEvents:UIControlEventTouchUpInside];
            return CommentsHeaderView;
        }

    }
    else if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {

            PlayerPageDescribeFooterView *describeFooterView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
                                    PlayerVC_Describe_FooterId
                                                              forIndexPath:indexPath];
            [describeFooterView.thumbUpButton addTarget:self action:@selector(thumbUpAction:)
                                       forControlEvents:UIControlEventTouchUpInside];
            describeFooterView.model = self.tempLessonDetailModel.result;
            return describeFooterView;
        }
        else if (indexPath.section == 2) {

            PlayerPageCommentsFooterView *CommentsFooterView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
                                    PlayerVC_Comments_FooterId
                                                              forIndexPath:indexPath];
            [CommentsFooterView.lookCommentsButton addTarget:self
                                                      action:@selector(CommentsFooterViewlookCommentsButton:)
                                            forControlEvents:UIControlEventTouchUpInside];
            return CommentsFooterView;
        }
    }
    return nil;
}

/** HeaderSize */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return CGSizeMake(SCREENWITH, 100);
    }
    else if (section == 1) {
        return CGSizeMake(SCREENWITH, 35);
    }
    else if (section == 2) {
        return CGSizeMake(SCREENWITH, 100);
    }

    return CGSizeZero;

}

/** FooterSize */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENWITH, 50);
    }
    else if (section == 2) {
        return CGSizeMake(SCREENWITH, 40);
    }
    return CGSizeZero;
}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.talkGridModel = self.talkGridListModel.result.data[indexPath.row];
        [self                                                                             requestCommentsData:
                [NSString stringWithFormat:@"%@%@/comments", talkGridcomments, self.talkGridModel.id_] method:GET];
        [self requestLessonListData:[NSString stringWithFormat:@"%@/%@", talkGrid, self.talkGridModel.id_] method:GET];
        [_playerView pause];
        [_playerView resetToPlayNewURL];
        TalkGridVideo *gridVideomodel = self.talkGridModel.video_player.firstObject;
        self.playUrl = gridVideomodel.url;
        _playerView.videoURL = [NSURL URLWithString:self.playUrl];
        if (self.talkGridModel.cover && self.talkGridModel.cover.count > 0) {
            TalkGridCover *tempCover = self.talkGridModel.cover.firstObject;
            _playerView.xjfloading_image = [UIImage imageWithData:
                                            [NSData dataWithContentsOfURL:[NSURL URLWithString:tempCover.url]]];
        }
        [_playerView play];

        [self sendPlayerHistoryToServerData:history method:POST];
    }
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.talkGridModel.content != nil && self.talkGridModel.content.length != 0) {
            CGRect tempRect = [StringUtil
                    calculateLabelRect:self.talkGridModel.content width:SCREENWITH - 20 fontsize:12];
            return CGSizeMake(SCREENWITH, tempRect.size.height + 10);
        }
        else {
            return CGSizeMake(SCREENWITH, 0);
        }
    }
    else if (indexPath.section == 1) {
        _layout.minimumLineSpacing = 1;
        CGFloat height;
        if (iPhone4 || iPhone5) {
            height = 140;
        }
        else if (iPhone6) {
            height = 155;
        }
        else if (iPhone6P) {
            height = 165;
        }
        return CGSizeMake((SCREENWITH - 2) / 2, height);
    }
    CommentsModel *model = self.commentsModel.result.data[indexPath.row];
    CGRect tempRect = [StringUtil calculateLabelRect:model.content width:SCREENWITH - 70 fontsize:15];
    return CGSizeMake(SCREENWITH, tempRect.size.height + 60);
}

#pragma mark- 右按钮展示视频描述详情

- (void)describeHeaderViewRightButtonAction:(UIButton *)sender {
    _isShowVideDescrible = !_isShowVideDescrible;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
//#pragma mark 视频下载
//- (void)describeHeaderViewdownLoadButtonAction:(UIButton *)sender
//{
//    NSLog(@"视频下载");
//}

#pragma mark 视频分享

- (void)describeHeaderViewshareButtonAction:(UIButton *)sender {
    _shareView.shareTitle = self.talkGridModel.title;
    _shareView.shareText = self.talkGridModel.content;
    _shareView.shareUrl = self.playUrl;
    if (self.talkGridModel.cover && self.talkGridModel.cover.count > 0) {
        TalkGridCover *tempCover = self.talkGridModel.cover.firstObject;
        _shareView.shareImage = tempCover.url;
    }
    _shareView.hidden = _shareView.hidden ? NO : YES;
}

#pragma mark 视频收藏

- (void)describeHeaderViewcollectionButtonAction:(UIButton *)sender {

    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    } else {
        if (self.tempLessonDetailModel.result.user_favored) {
            [self requestLessonListData:favorite method:DELETE];
        } else if (!self.tempLessonDetailModel.result.user_favored) {
            [self requestLessonListData:favorite method:POST];
        }
    }
}

#pragma mark 查看全部评论

- (void)CommentsFooterViewlookCommentsButton:(UIButton *)sender {
    CommentsViewController *allComents = [CommentsViewController new];
    allComents.ID = self.self.talkGridModel.id_;
    [self.navigationController pushViewController:allComents animated:YES];
}

#pragma mark 评论

- (void)comments:(UIButton *)sender {
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    } else {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark 发表评论

- (void)sendCommentMsg:(UIButton *)sender {
    NSString *tempApi = [NSString stringWithFormat:@"%@%@/comments", talkGridcomments, self.talkGridModel.id_];
    [self requestCommentsData:tempApi method:POST];
    [self.textField resignFirstResponder];
}

#pragma mark 点赞

- (void)thumbUpAction:(UIButton *)sender {

    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    } else {
        LessonDetailListResultModel *lessonDetailListResultModel = self.tempLessonDetailModel.result;
        //已点赞，进行取消点赞
        if (lessonDetailListResultModel.user_liked) {
            [self PraiseAction:praise Method:DELETE];
            //未点赞，进行点赞
        } else {
            [self PraiseAction:praise Method:POST];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}


#pragma mark- KeyboardAction

/** UIKeyboardWillHide */
- (void)UIKeyboardWillHide:(NSNotification *)notifation {
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
    }];
    self.keyBoardAppearView.hidden = YES;
}


/** keyBoardwillAppear */
- (void)keyBoardwillAppear:(NSNotification *)notifation {
    CGRect KeyboardFrame = [[notifation.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.keyBoardAppearView.hidden = NO;
    //UIView动画
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0,
                self.view.frame.size.height - KeyboardFrame.size.height - 50,
                self.view.frame.size.width,
                50);
    }];
}

- (void)keyBoardresignFirstResponder:(UITapGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
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
}
@end
