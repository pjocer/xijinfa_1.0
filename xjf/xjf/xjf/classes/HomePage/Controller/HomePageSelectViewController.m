//
//  HomePageSelectViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageSelectViewController.h"
#import "HomePageConfigure.h"


@interface HomePageSelectViewController ()<UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDelegateFlowLayout,
                                            HomePageScrollCellDelegate>

typedef NS_OPTIONS(NSInteger, SelectViewControllerSectionType) {
    HomePageBannerSection = 0,
    HomePageWikipediaSection,
    HomePageSchoolSection,
    HomePageEmployedSection
};

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayThumbnailByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) TablkListModel *tablkListModel_Lesson;
@end

@implementation HomePageSelectViewController

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
            self.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
            if (self.bannermodel.result == nil || self.bannermodel.errMsg != nil) {
                [[ZToastManager ShardInstance] showtoast:self.bannermodel.errMsg];
            }
            [subscriber sendNext:self.bannermodel];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];

    RACSignal *ProjectListDat = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Employed RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.projectListByModel];
        }failedBlock:^(NSError *_Nullable error) {
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
    
    RACSignal *requestCategoriesTalkGridData = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:talkGrid RequestMethod:GET];
        @weakify(self);
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self);
            self.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.tablkListModel];
        }failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUI:data2:data3:data4:) withSignalsFromArray:@[ProjectListDat, requestLessonList, requestCategoriesTalkGridData,requestBannerData]];
}

- (void)updateUI:(ProjectListByModel *)data1 data2:(TablkListModel *)data2 data3:(TablkListModel *)data3 data4:(BannerModel *)data4{
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
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerText_Cell];
    [_collectionView registerClass:[HomePageBanderCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerBander_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFWikipediaCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByWikipedia_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    [_collectionView registerClass:[HomePageScrollCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerHomePageScrollCell_CellID];
    
    [_collectionView registerClass:[HomePageCollectionSectionHeaderView class]
            forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == HomePageBannerSection) {
        return 1;
    }else if (section == HomePageWikipediaSection) {
        return self.tablkListModel.result.data.count > 4 ? 4 : self.tablkListModel.result.data.count;
    }else if (section == HomePageSchoolSection) {
        return self.tablkListModel_Lesson.result.data.count > 4 ? 4 : self.tablkListModel_Lesson.result.data.count;
    }else if (section == HomePageEmployedSection) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HomePageBannerSection) {
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
    }else if (indexPath.section == HomePageWikipediaSection){
        XJFWikipediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionByWikipedia_CellID forIndexPath:indexPath];
        cell.model = self.tablkListModel.result.data[indexPath.row];
        return cell;
    }else if (indexPath.section == HomePageSchoolSection){
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        cell.model = self.tablkListModel_Lesson.result.data[indexPath.row];
        return cell;
    }else if (indexPath.section == HomePageEmployedSection){
        HomePageScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
            HomePageSelectViewControllerHomePageScrollCell_CellID forIndexPath:indexPath];
        cell.ClassificationType = HomePageEmployedassification;
        cell.delegate = self;
        cell.projectListByModel = self.projectListByModel;
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
           HomePageSelectViewControllerText_Cell forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCollectionSectionHeaderView *sectionHeaderView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
     HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    sectionHeaderView.sectionTitle.text = @[@"",@"析金百科",@"析金学堂",@"析金从业"][indexPath.section];
    sectionHeaderView.sectionMore.text = @[@"",@"更多",@"更多",@""][indexPath.section];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapPUSHMorePage:)];
    [sectionHeaderView addGestureRecognizer:tap];
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == HomePageBannerSection) {
        return CGSizeZero;
    }else if (section == HomePageWikipediaSection && self.tablkListModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageSchoolSection && self.tablkListModel_Lesson.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageEmployedSection && self.projectListByModel.result.data.count > 0){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }
    return CGSizeZero;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == HomePageBannerSection) {
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == HomePageWikipediaSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
        _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
        return KHomePageCollectionByLessons;
    }else if (indexPath.section == HomePageSchoolSection){
        return KHomePageCollectionByLessons;
    }else if (indexPath.section == HomePageEmployedSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return KHomePageCollectionByClassificationAndTeacher;
    }
    
    return CGSizeZero;
}

#pragma mark - sectionHeaderViewTapPUSHMorePage

- (void)sectionHeaderViewTapPUSHMorePage:(UITapGestureRecognizer *)sender
{
    HomePageCollectionSectionHeaderView *sectionHeaderView = (HomePageCollectionSectionHeaderView *)sender.view;
    if ([sectionHeaderView.sectionTitle.text isEqualToString:@"析金百科"]) {
        VideolistViewController *videolListPage = [VideolistViewController new];
        videolListPage.title = @"析金百科更多";
        [self.navigationController pushViewController:videolListPage animated:YES];
    }else if ([sectionHeaderView.sectionTitle.text isEqualToString:@"析金学堂"]){
        LessonListViewController *lessonlListPage = [[LessonListViewController alloc] init];
        lessonlListPage.LessonListTitle = @"析金学堂更多";
        [self.navigationController pushViewController:lessonlListPage animated:YES];
    }
}

#pragma mark - delegate

#pragma mark homePageScrollCell didSelectItemAtIndexPath
- (void)homePageScrollCell:(HomePageScrollCell *)homePageScrollCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmployedLessonListViewController *employedLessonListViewController = [[EmployedLessonListViewController alloc] init];
    ProjectList *tempModel = self.projectListByModel.result.data[indexPath.row];
    
    for (ProjectList *model in tempModel.children) {
        if ([model.title isEqualToString:@"基础知识"]) {
            employedLessonListViewController.employedBasisID = model.id;
        }
        else if ([model.title isEqualToString:@"法律法规"]) {
            employedLessonListViewController.employedLawsID = model.id;
        }
        else if ([model.title isEqualToString:@"全科"]) {
            employedLessonListViewController.employedGeneralID = model.id;
        }
    }
    employedLessonListViewController.employedLessonList = tempModel.title;
    [self.navigationController pushViewController:employedLessonListViewController animated:YES];
}

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HomePageWikipediaSection) {
        PlayerViewController *playerPage = [PlayerViewController new];
        TalkGridModel *model = self.tablkListModel.result.data[indexPath.row];
        playerPage.talkGridModel = model;
        playerPage.talkGridListModel = self.tablkListModel;
        [self.navigationController pushViewController:playerPage animated:YES];
    }else if (indexPath.section == HomePageSchoolSection) {
        LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
        lessonDetailViewController.model = self.tablkListModel_Lesson.result.data[indexPath.row];
        lessonDetailViewController.apiType = coursesProjectLessonDetailList;
        [self.navigationController pushViewController:lessonDetailViewController animated:YES];
    }
}

@end
