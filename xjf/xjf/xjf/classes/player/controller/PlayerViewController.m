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
#import "playerConfigure.h"

@interface PlayerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIView *playView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataSource; /**< 数据源 */
///是否展示视频描述
@property (nonatomic, assign) BOOL isShowVideDescrible;

@end

static NSString * PlayerVC_Describe_HeaderId = @"PlayerVC_Describe_HeaderId";
static NSString * PlayerVC_Describe_FooterId = @"PlayerVC_Describe_FooterId";
static NSString * PlayerVC_Recommended_HeaderId = @"PlayerVC_Recommended_HeaderId";
static NSString * PlayerVC_Comments_HeaderId = @"PlayerVC_Comments_HeaderId";
static NSString * PlayerVC_Comments_FooterId = @"PlayerVC_Comments_FooterId";

static NSString * PlayerVC_Describe_Cell_Id = @"PlayerVC_Describe_Cell_Id";
static NSString * PlayerVC_TalkGrid_Cell_Id = @"PlayerVC_TalkGrid_Cell_Id";
static NSString * PlayerVC_Comments_Cell_Id = @"PlayerVC_Comments_Cell_Id";

@implementation PlayerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowVideDescrible = YES; //默认展示视频详情
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
#pragma mark 横竖屏状态
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = BackgroundColor;
        self.collectionView.hidden = NO;
        self.playerView.frame =CGRectMake(0, 20, SCREENHEIGHT, 211);
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        self.collectionView.hidden = YES;
        self.playerView.frame =CGRectMake(0, 0, SCREENHEIGHT,SCREENWITH);
    }
}

#pragma mark- mainUI
-(void)initMainUI
{
    [self initPlayerView];
    [self initCollectionView];
}
#pragma mark PlayerView
- (void) initPlayerView
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
#pragma mark CollectionView
- (void)initCollectionView
{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//针对分区 
    _layout.minimumLineSpacing = 0.0;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0.0;//左右间隔
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playView.frame), SCREENWITH, SCREENHEIGHT - CGRectGetMaxY(self.playView.frame)) collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    //注册
    [self.collectionView registerClass:[PlayerPageDescribeCell class] forCellWithReuseIdentifier:PlayerVC_Describe_Cell_Id];
    [self.collectionView registerClass:[WikiTalkGridViewCell class] forCellWithReuseIdentifier:PlayerVC_TalkGrid_Cell_Id];
    [self.collectionView registerClass:[PlayerPageCommentsCell class] forCellWithReuseIdentifier:PlayerVC_Comments_Cell_Id];
    
    [self.collectionView registerClass:[PlayerPageDescribeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PlayerVC_Describe_HeaderId];
    [self.collectionView registerClass:[PlayerPageDescribeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PlayerVC_Describe_FooterId];
    
    [self.collectionView registerClass:[PlayerPageRecommendedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PlayerVC_Recommended_HeaderId];
    
    [self.collectionView registerClass:[PlayerPageCommentsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PlayerVC_Comments_HeaderId];
    [self.collectionView registerClass:[PlayerPageCommentsFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PlayerVC_Comments_FooterId];
    
    
}
#pragma mark- CollectionViewDelegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isShowVideDescrible) {
            return 1;
        }
        else if (!self.isShowVideDescrible) {
            return 0;
        }
        
    }
    else if (section == 1) {
        return 4;
    }
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PlayerPageDescribeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Describe_Cell_Id forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 1) {
        WikiTalkGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_TalkGrid_Cell_Id forIndexPath:indexPath];
        return cell;
    }
    PlayerPageCommentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Comments_Cell_Id forIndexPath:indexPath];
    return cell;
    
}

/** Header And Footer */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            
            PlayerPageDescribeHeaderView *describeHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Describe_HeaderId forIndexPath:indexPath];
            [describeHeaderView.rightButton addTarget:self action:@selector(describeHeaderViewRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
           [describeHeaderView.downLoadButton addTarget:self action:@selector(describeHeaderViewdownLoadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
           [describeHeaderView.shareButton addTarget:self action:@selector(describeHeaderViewshareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
           [describeHeaderView.collectionButton addTarget:self action:@selector(describeHeaderViewcollectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            return describeHeaderView;
        }
        else if (indexPath.section == 1) {
            
            PlayerPageRecommendedHeaderView *recommendedHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Recommended_HeaderId forIndexPath:indexPath];
            return recommendedHeaderView;
        }
        else if (indexPath.section == 2) {
            
            PlayerPageCommentsHeaderView *CommentsHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Comments_HeaderId forIndexPath:indexPath];
            [CommentsHeaderView.commentsButton addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
            return CommentsHeaderView;
        }
        
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            
            PlayerPageDescribeFooterView *describeFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Describe_FooterId forIndexPath:indexPath];
            return describeFooterView;
        }
        else if (indexPath.section == 2) {
            
            PlayerPageCommentsFooterView *CommentsFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Comments_FooterId forIndexPath:indexPath];
            [CommentsFooterView.lookCommentsButton addTarget:self action:@selector(CommentsFooterViewlookCommentsButton:) forControlEvents:UIControlEventTouchUpInside];
            return CommentsFooterView;
        }
    }
    return nil;
}

/** HeaderSize */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREENWITH, 50);
    }
    else if (section == 2) {
        return CGSizeMake(SCREENWITH, 40);
    }
    return CGSizeZero;
}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"didSelectItemAtIndexPath section:%ld  row:%ld",indexPath.section,indexPath.row);
    
}

#pragma mark FlowLayoutDelegate
/** 每个分区item的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  CGSizeMake(SCREENWITH, 100);
    }
    else if (indexPath.section == 1) {
        _layout.minimumLineSpacing = 1;
        return CGSizeMake((SCREENWITH - 2)/ 2, 150);
    }
    return CGSizeMake(SCREENWITH, 100);
}

#pragma mark- 右按钮展示视频描述详情
- (void)describeHeaderViewRightButtonAction:(UIButton *)sender
{
    NSLog(@"右按钮展示视频描述详情");
    _isShowVideDescrible = !_isShowVideDescrible;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
#pragma mark 视频下载
- (void)describeHeaderViewdownLoadButtonAction:(UIButton *)sender
{
    NSLog(@"视频下载");
}

#pragma mark 视频分享
- (void)describeHeaderViewshareButtonAction:(UIButton *)sender
{
    NSLog(@"视频分享");
}

#pragma mark 视频收藏
- (void)describeHeaderViewcollectionButtonAction:(UIButton *)sender
{
    NSLog(@"视频收藏");
}
#pragma mark 查看全部评论
- (void)CommentsFooterViewlookCommentsButton:(UIButton *)sender
{
    NSLog(@"查看全部评论");
}
#pragma mark 评论
- (void)comments:(UIButton *)sender
{
    NSLog(@"评论");
}


#pragma mark- dealloc
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

@end
