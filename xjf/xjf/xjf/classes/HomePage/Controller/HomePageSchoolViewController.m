//
//  HomePageSchoolViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageSchoolViewController.h"
#import "HomePageConfigure.h"
#import "TeacherListHostModel.h"
#import "TeacherScrollCollectionViewCell.h"
#import "TeacherListViewController.h"
#import "TeacherDetalPage.h"

@interface HomePageSchoolViewController ()<UICollectionViewDataSource,
                                                UICollectionViewDelegate,
                                                UICollectionViewDelegateFlowLayout,
                                                HomePageScrollCellDelegate,
                                                TeacherScrollCollectionViewCellDelegate>

typedef NS_OPTIONS(NSInteger, WikipediaControllerSectionType) {
    HomePageSchoolViewControllerBannerSection = 0,
    HomePageSchoolViewControllerClassificationSection,
    HomePageSchoolViewControllerLessonSection,
    HomePageSchoolViewControllerTeacher
};

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayThumbnailByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
@property (nonatomic, strong) TablkListModel *tablkListModel_Lesson;
@property (nonatomic, strong) TeacherListHostModel *teacherListHostModel;
@end

@implementation HomePageSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self RequestData];
}


#pragma mark - RequestData

- (void)RequestData {
    RACSignal *requestBannerData = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:appHomeCarousel RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            if (self.bannermodel.errCode == 0) {
                self.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
                if (self.bannermodel.result == nil || self.bannermodel.errMsg != nil) {
                    [[ZToastManager ShardInstance] showtoast:self.bannermodel.errMsg];
                }
                [subscriber sendNext:self.bannermodel];
            }else{
                [[ZToastManager ShardInstance] showtoast:self.bannermodel.errMsg];
            }
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    
    RACSignal *ProjectListDat = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:projectList RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.projectListByModel];
        }                  failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    
    RACSignal *requestLessonList = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:coursesProjectLessonDetailList RequestMethod:GET];
        @weakify(self);
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.tablkListModel_Lesson = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.tablkListModel_Lesson];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    
    RACSignal *requestTeacherData = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:teacherListHot RequestMethod:GET];
        @weakify(self);
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self);
            self.teacherListHostModel = [[TeacherListHostModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.teacherListHostModel];
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUI:data2:data3:data4:) withSignalsFromArray:@[ProjectListDat, requestLessonList, requestTeacherData,requestBannerData]];
}

- (void)updateUI:(ProjectListByModel *)data1 data2:(TablkListModel *)data2 data3:(TeacherListHostModel *)data3 data4:(BannerModel *)data4{
    if (data4.result != nil) {
        self.dataArrayThumbnailByBanner = [NSMutableArray array];
        for (BannerResultModel *model in self.bannermodel.result.data) {
            if (model.cover && model.cover.count > 0) {
                ProjectListCover *cover = model.cover.firstObject;
                [self.dataArrayThumbnailByBanner addObject:cover.url];
            }
        }
    }
    [self.collectionView reloadData];
}


#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _layout.minimumLineSpacing = 0.0;
    _layout.minimumInteritemSpacing = 0.0;
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - kTabBarH - 38 - kNavigationBarH - kStatusBarH)
                           collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
  
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    [_collectionView registerClass:[HomePageBanderCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerBander_CellID];
    [_collectionView registerClass:[HomePageScrollCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerHomePageScrollCell_CellID];
      [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerText_Cell];
    [_collectionView registerClass:[TeacherScrollCollectionViewCell class] forCellWithReuseIdentifier:@"TeacherScrollCollectionViewCell_ID"];

    [_collectionView registerClass:[HomePageCollectionSectionHeaderView class] forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == HomePageSchoolViewControllerBannerSection) {
        return 1;
    }else if (section == HomePageSchoolViewControllerClassificationSection) {
        return 1;
    }else if (section == HomePageSchoolViewControllerLessonSection) {
        return self.tablkListModel_Lesson.result.data.count > 8 ? 8 : self.tablkListModel_Lesson.result.data.count;
    }else if (section == HomePageSchoolViewControllerTeacher) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == HomePageSchoolViewControllerBannerSection) {
        HomePageBanderCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerBander_CellID
                                    forIndexPath:indexPath];
        cell.carouselView.imageArray = self.dataArrayThumbnailByBanner;
        @weakify(self);
        cell.carouselView.imageClickBlock = ^(NSInteger index) {
            @strongify(self);
            BannerWebViewViewController *bannerWebViewViewController = [BannerWebViewViewController new];
            BannerResultModel *model = self.bannermodel.result.data[index];
            bannerWebViewViewController.webHtmlUrl = model.link;
            [self.navigationController pushViewController:bannerWebViewViewController animated:YES];
        };
        return cell;
    }else if (indexPath.section == HomePageSchoolViewControllerClassificationSection){
        HomePageScrollCell *homePageScrollCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageSelectViewControllerHomePageScrollCell_CellID forIndexPath:indexPath];
        homePageScrollCell.ClassificationType = HomePageSchoolClassification;
        homePageScrollCell.delegate = self;
        homePageScrollCell.projectListByModel = self.projectListByModel;
        return homePageScrollCell;
    }else if (indexPath.section == HomePageSchoolViewControllerLessonSection){
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        cell.model = self.tablkListModel_Lesson.result.data[indexPath.row];
        return cell;
    }else if (indexPath.section == HomePageSchoolViewControllerTeacher){
        TeacherScrollCollectionViewCell *teacherScrollCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TeacherScrollCollectionViewCell_ID" forIndexPath:indexPath];

        teacherScrollCollectionViewCell.delegate = self;
        teacherScrollCollectionViewCell.teacherListHostModel = self.teacherListHostModel;
        return teacherScrollCollectionViewCell;
    }
    
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:
                                  HomePageSelectViewControllerText_Cell
                                  forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCollectionSectionHeaderView *sectionHeaderView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
     HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    
//    __unsafe_unretained __typeof(sectionHeaderView) weaksectionHeaderView = sectionHeaderView;
    [sectionHeaderView setTitle:@[@"",@"全部分类",@"热门课程",@"析金讲师"][indexPath.section] moreTitle:@"" moreCallback:^(id gestureRecognizer) {
//        if ([weaksectionHeaderView.sectionTitle.text isEqualToString:@"析金讲师"]){
//            TeacherListViewController *teacherListViewController = [TeacherListViewController new];
//            teacherListViewController.navigationItem.title = @"全部老师";
//            [self.navigationController pushViewController:teacherListViewController animated:YES];
//        }
    }];
    
    
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == HomePageSchoolViewControllerBannerSection) {
        return CGSizeZero;
    }else if (section == HomePageSchoolViewControllerClassificationSection && self.projectListByModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageSchoolViewControllerLessonSection && self.tablkListModel_Lesson.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageSchoolViewControllerTeacher && self.teacherListHostModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }
    return CGSizeZero;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == HomePageSchoolViewControllerBannerSection) {
        _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == HomePageSchoolViewControllerClassificationSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return KHomePageCollectionByClassification;
    }else if (indexPath.section == HomePageSchoolViewControllerLessonSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
        _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
        return KHomePageCollectionByLessons;
    }else if (indexPath.section == HomePageSchoolViewControllerTeacher){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        return KHomePageCollectionTeacher;
    }
    
    return CGSizeZero;
}

#pragma mark - delegate

#pragma mark TeacherScrollCollectionViewCellDelegate

-(void)teacherScrollCollectionViewCell:(TeacherScrollCollectionViewCell *)teacherScrollCollectionViewCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherDetalPage *teacherDetailViewController = [[TeacherDetalPage alloc] init];
    teacherDetailViewController.teacherListDataModel = self.teacherListHostModel.result.data[indexPath.row];
    [self.navigationController pushViewController:teacherDetailViewController animated:YES];
}

#pragma mark homePageScrollCell didSelectItemAtIndexPath

- (void)homePageScrollCell:(HomePageScrollCell *)homePageScrollCell
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
       ClassificationTitle:(NSString *)title
{
    ProjectList *model = self.projectListByModel.result.data[indexPath.row];
    AllLessonListViewController *listViewController = [AllLessonListViewController new];
    listViewController.lessonListPageLessonType = LessonListPageSchool;
    listViewController.ID = model.id;
    listViewController.lessonListTitle = title;
    [self.navigationController pushViewController:listViewController animated:YES];
}

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HomePageSchoolViewControllerLessonSection) {
         TalkGridModel *model = self.tablkListModel_Lesson.result.data[indexPath.row];
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    }
}


@end
