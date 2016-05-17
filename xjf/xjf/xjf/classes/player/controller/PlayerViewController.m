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
#import "CommentsModel.h"

@interface PlayerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property(nonatomic,strong)UIView *playView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;

///是否展示视频描述
@property (nonatomic, assign) BOOL isShowVideDescrible;

@property (nonatomic, retain) UIView *keyBoardView; /**< 键盘背景图 */
@property (nonatomic, retain) UIView *keyBoardAppearView; /**< 键盘出现，屏幕背景图 */
@property (nonatomic, retain) UITextField *textField; /**< 键盘 */

///评论api
@property (nonatomic, strong) NSString *api;
///评论数据
@property (nonatomic, strong) CommentsAllDataList *commentsModel;

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
    self.api = [NSString stringWithFormat:@"%@%@/comments",talkGridcomments,self.talkGridModel.id_];
    
    
    [self requestCommentsData:self.api method:GET];
    
}
#pragma mark requestData
- (void)requestCommentsData:(APIName *)api method:(RequestMethod)method
{
    //GET
    if (method == 0) {
        @weakify(self)
        [[ZToastManager ShardInstance] showprogress];
        XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
        
        [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        @strongify(self)
            if (self.commentsModel.errCode == 0) {
                [[ZToastManager ShardInstance] hideprogress];
                self.commentsModel = [[CommentsAllDataList alloc]initWithData:responseData error:nil];
                [self.collectionView reloadData];
            }else
                {[[ZToastManager ShardInstance] hideprogress];
                [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
            }
            
        } failedBlock:^(NSError * _Nullable error) {
            [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
        }];
    }
    //POST
    else if (method == 1)
    {
        XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.textField.text forKey:@"comments"];
        [dic setValue:self.talkGridModel.id_ forKey:@"ID"];
        request.requestParams = dic;
        @weakify(self)
        [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
            @strongify(self)

            if (self.commentsModel.errCode == 0) {
                self.commentsModel = [[CommentsAllDataList alloc]initWithData:responseData error:nil];
                [self.collectionView reloadData];
            }else
            {
                [[ZToastManager ShardInstance]showtoast:self.commentsModel.errMsg];
            }
            
            
        } failedBlock:^(NSError * _Nullable error) {
            [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
        }];

    }

    
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
    [self initTextField];
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
//    self.playUrl = @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4";
//    self.playUrl = @"http://api.dev.xijinfa.com/api/video-player/51197.m3u8";
    self.playUrl = self.talkGridModel.auto_;
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
//    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//针对分区 
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
#pragma mark 键盘
/**键盘 */
- (void)initTextField
{
    self.keyBoardAppearView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.keyBoardAppearView.backgroundColor = [UIColor blackColor];
    self.keyBoardAppearView.alpha = 0.2;
    [self.view addSubview:self.keyBoardAppearView];
    self.keyBoardAppearView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardresignFirstResponder:)];
    [self.keyBoardAppearView addGestureRecognizer:tap];
    
    
    self.keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    self.keyBoardView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.keyBoardView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2,5,250,30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"请输入";
    [self.keyBoardView addSubview:self.textField];
    self.textField.delegate = self;
    
    
    //UIKeyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardwillAppear:) name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    return self.commentsModel.result.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PlayerPageDescribeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Describe_Cell_Id forIndexPath:indexPath];
        cell.model = self.talkGridModel;
        return cell;
    }
    else if (indexPath.section == 1) {
        WikiTalkGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_TalkGrid_Cell_Id forIndexPath:indexPath];
        return cell;
    }
    PlayerPageCommentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayerVC_Comments_Cell_Id forIndexPath:indexPath];
    
    cell.commentsModel = self.commentsModel.result.data[indexPath.row];
    return cell;
    
}

/** Header And Footer */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            
            PlayerPageDescribeHeaderView *describeHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PlayerVC_Describe_HeaderId forIndexPath:indexPath];
            describeHeaderView.title.text = self.talkGridModel.title;
            
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
        if (self.talkGridModel.content != nil && self.talkGridModel.content.length != 0) {
            CGRect tempRect = [StringUtil calculateLabelRect:self.talkGridModel.content width:SCREENWITH - 20 fontsize:12];
            return  CGSizeMake(SCREENWITH, tempRect.size.height + 10);
        }
        else
        {
            return CGSizeMake(SCREENWITH,0);
        }
    }
    else if (indexPath.section == 1) {
        _layout.minimumLineSpacing = 1;
        CGFloat height;
        if (iPhone4 || iPhone5)
        {
            height = 140;
        }
        else if (iPhone6)
        {
            height = 155;
        }
        else if (iPhone6P)
        {
            height = 165;
        }
        return CGSizeMake((SCREENWITH - 2)/ 2, height);
    }
    CommentsModel *model = self.commentsModel.result.data[indexPath.row];
    CGRect tempRect = [StringUtil calculateLabelRect:model.content width:SCREENWITH - 70 fontsize:12];
    return CGSizeMake(SCREENWITH, tempRect.size.height + 70);
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
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}
#pragma mark 评论
- (void)comments:(UIButton *)sender
{
    NSLog(@"评论");
    [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestCommentsData:self.api method:POST];
    [self.textField resignFirstResponder];
    return YES;
}


#pragma mark- KeyboardAction
/** UIKeyboardWillHide */
- (void)UIKeyboardWillHide:(NSNotification *)notifation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
    }];
    self.keyBoardAppearView.hidden = YES;
}


/** keyBoardwillAppear */
- (void)keyBoardwillAppear:(NSNotification *)notifation
{
    NSLog(@"%@",notifation);
    CGRect KeyboardFrame = [[notifation.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(KeyboardFrame));
    self.keyBoardAppearView.hidden = NO;
    //UIView动画
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0 , self.view.frame.size.height - KeyboardFrame.size.height -50, self.view.frame.size.width, 50);
    }];
}

- (void)keyBoardresignFirstResponder:(UITapGestureRecognizer *)sender{
    [self.textField resignFirstResponder];
}


#pragma mark- dealloc
- (void)dealloc
{
    if (_playerView) {
        [_playerView cancelAutoFadeOutControlBar];
        [_playerView pause];
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
