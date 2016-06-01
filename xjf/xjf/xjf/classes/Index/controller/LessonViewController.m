//
//  LessonViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonViewController.h"
#import "IndexConfigure.h"
#import "BannerModel.h"
#import "LessonPlayerViewController.h"
#import "LessonListViewController.h"
#import "ProjectListByModel.h"
#import "XJAccountManager.h"
#import "AlertUtils.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "TeacherListHostModel.h"
#import "TeacherDetailViewController.h"
@interface LessonViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout, XRCarouselViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, retain) UICollectionViewFlowLayout *layout;
@property(nonatomic, retain) NSMutableArray *dataArrayByBanner;
/**< 广告数据源 */
@property(nonatomic, strong) BannerModel *bannermodel;
///视频专题列表数据
@property(nonatomic, strong) NSMutableArray *coursesProjectListDataArray;
@property(nonatomic, strong) TeacherListHostModel *teacherListHostModel;
@end

static NSString *lessonBannerView_HeaderId = @"lessonBannerView_HeaderId";
static NSString *LessonIndexCell_Id = @"lLessonIndexCell_Id";
static NSString *teacher_HeaderId = @"teacher_HeaderId";
static NSString *teacherCell_Id = @"teacherCell_Id";

@implementation LessonViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requestBannerData:appDeptCarousel3 method:GET];
    [self requesProjectListDat:projectList method:GET];
    [self requestTeacherData:teacherListHot method:GET];
}

#pragma mark requestData

- (void)requestBannerData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    self.dataArrayByBanner = [NSMutableArray array];
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    //bannermodel
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {

        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        sSelf.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
        for (BannerResultModel *model in sSelf.bannermodel.result.data) {
            [self.dataArrayByBanner addObject:model.thumbnail];
        }
     
        [sSelf.collectionView reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];

}

- (void)requesProjectListDat:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    self.coursesProjectListDataArray = [NSMutableArray array];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        for (NSDictionary *dic in result[@"result"][@"data"]) {
            ProjectListByModel *model = [[ProjectListByModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [sSelf.coursesProjectListDataArray addObject:model];
        }
         [sSelf.collectionView reloadData];

    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

- (void)requestTeacherData:(APIName *)api method:(RequestMethod)method{
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    
    //TeacherListHostModel
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.teacherListHostModel = [[TeacherListHostModel alloc] initWithData:responseData error:nil];
        [sSelf.collectionView reloadData];
        
    }                  failedBlock:^(NSError *_Nullable error) {
         [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

#pragma mark -- Navigation

- (void)setNavigation {
    self.navigationItem.title = @"析金学堂";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"search"]
                    style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    //导航栏右按钮 搜索
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);//针对分区
    _layout.minimumLineSpacing = 0.0;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0.0;//左右间隔

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                    0,
                    SCREENWITH,
                    SCREENHEIGHT - 10)
                                             collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[LessonIndexCell class] forCellWithReuseIdentifier:LessonIndexCell_Id];
    [self.collectionView registerClass:[TearcherIndexCell class] forCellWithReuseIdentifier:teacherCell_Id];

    //注册header
    [self.collectionView registerClass:[WikiBannerView class]
            forSupplementaryViewOfKind:
                    UICollectionElementKindSectionHeader withReuseIdentifier:lessonBannerView_HeaderId];
    [self.collectionView registerClass:[WikiSectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:teacher_HeaderId];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.coursesProjectListDataArray.count;
    }
    else if (section == 1) {
        return 3;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LessonIndexCell *cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:LessonIndexCell_Id forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.model = self.coursesProjectListDataArray[indexPath.row];
        return cell;
    }

    TearcherIndexCell *cell = [collectionView
            dequeueReusableCellWithReuseIdentifier:teacherCell_Id forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.teacherListHostModel.result.data[indexPath.row];
    return cell;
}

/** 头视图 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            WikiBannerView *wikiBannerView =
                    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
                            lessonBannerView_HeaderId         forIndexPath:indexPath];
            wikiBannerView.carouselView.delegate = self;
            wikiBannerView.carouselView.imageArray = self.dataArrayByBanner;

            return wikiBannerView;
        }
        else if (indexPath.section == 1) {
            WikiSectionHeaderView *wikiSectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
            withReuseIdentifier:teacher_HeaderId forIndexPath:indexPath];
            wikiSectionHeaderView.titleLabel.text = @"人气讲师";
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(handleSingleTapFrom)];
            [wikiSectionHeaderView addGestureRecognizer:singleRecognizer];
            return wikiSectionHeaderView;
        }

    }
    return nil;
}

- (void)handleSingleTapFrom {
    TeacherListViewController *teacherListViewController = [TeacherListViewController new];
    teacherListViewController.hostModel = self.teacherListHostModel;
    [self.navigationController pushViewController:teacherListViewController animated:YES];
}

- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {
    NSLog(@"点击..... %ld", index);
}

/** Header大小 */
- (CGSize)       collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return CGSizeMake(SCREENWITH, 175);
    }
    else if (section == 1) {
        return CGSizeMake(SCREENWITH, 35);
    }

    return CGSizeZero;

}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {

        [AlertUtils alertWithTarget:self title:@"登录您将获得更多功能"
                            okTitle:@"登录"
                         otherTitle:@"注册"
                  cancelButtonTitle:@"取消"
                            message:@"参与话题讨论\n\n播放记录云同步\n\n更多金融专业课程"
                        cancelBlock:^{
                            NSLog(@"取消");
                        } okBlock:^{
                    LoginViewController *loginPage = [LoginViewController new];
                    [self.navigationController pushViewController:loginPage animated:YES];
                }        otherBlock:^{
                    RegistViewController *registPage = [RegistViewController new];
                    registPage.title_item = @"注册";
                    [self.navigationController pushViewController:registPage animated:YES];
                }];

    } else {
        if (indexPath.section == 0) {
            LessonListViewController *lessonListViewController = [LessonListViewController new];
            ProjectListByModel *model = self.coursesProjectListDataArray[indexPath.row];;
            lessonListViewController.LessonListTitle = model.title;
            lessonListViewController.ID = model.ID;
            [self.navigationController pushViewController:lessonListViewController animated:YES];
        }
        else if (indexPath.section == 1) {
            TeacherDetailViewController *teacherDetailViewController = [[TeacherDetailViewController alloc] init];
            [self.navigationController pushViewController:teacherDetailViewController animated:YES];
        }
    }
}

#pragma mark FlowLayoutDelegate

/** 每个分区item的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _layout.minimumLineSpacing = 1;
        if (indexPath.row == 0 || indexPath.row == 5) {
            return CGSizeMake(SCREENWITH, 100);
        }
        else {
            return CGSizeMake((SCREENWITH - 2) / 2, 100);
        }

    } else {
        _layout.minimumLineSpacing = 1;
        return CGSizeMake((SCREENWITH - 3) / 3, 150);
    }
}

@end
