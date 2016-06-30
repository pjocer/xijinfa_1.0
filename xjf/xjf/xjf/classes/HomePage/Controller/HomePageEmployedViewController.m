//
//  HomePageEmployedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageEmployedViewController.h"
#import "HomePageConfigure.h"

@interface HomePageEmployedViewController ()<UICollectionViewDataSource,
                                                    UICollectionViewDelegate,
                                                    UICollectionViewDelegateFlowLayout,
                                                    HomePageScrollCellDelegate>

typedef NS_OPTIONS(NSInteger, WikipediaControllerSectionType) {
    HomePageBannerSection = 0,
    HomePageClassificationSection,
    HomePageWikipediaSection
};
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayThumbnailByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
@property (nonatomic, strong) TablkListModel *tablkListModelByArticles;
@end

@implementation HomePageEmployedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self RequestData];
}

#pragma mark - RequestData

- (void)RequestData {
    RACSignal *requestBannerData = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:appDeptCarousel4 RequestMethod:GET];
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
    
    RACSignal *articlesSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Articles RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.tablkListModelByArticles = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.tablkListModelByArticles];
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
    
    [self rac_liftSelector:@selector(updateUI:data2:data3:) withSignalsFromArray:@[articlesSignal, ProjectListDat,requestBannerData]];
}

- (void)updateUI:(TablkListModel *)data1 data2:(ProjectListByModel *)data2 data3:(BannerModel *)data3{
    if (data3.result != nil) {
        self.dataArrayThumbnailByBanner = [NSMutableArray array];
        for (BannerResultModel *model in self.bannermodel.result.data) {
            [self.dataArrayThumbnailByBanner addObject:model.thumbnail];
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
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFEmploymentInformationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:XJFEmploymentInformationCollectionViewCell_ID];
    [_collectionView registerClass:[HomePageBanderCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerBander_CellID];
    [_collectionView registerClass:[HomePageScrollCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerHomePageScrollCell_CellID];
    
    [_collectionView registerClass:[HomePageCollectionSectionHeaderView class]
        forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == HomePageBannerSection) {
        return 1;
    }else if (section == HomePageClassificationSection) {
        return 1;
    }else if (section == HomePageWikipediaSection) {
        return self.tablkListModelByArticles.result.data.count;
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
    }else if (indexPath.section == HomePageClassificationSection){
        HomePageScrollCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerHomePageScrollCell_CellID
                                    forIndexPath:indexPath];
        cell.delegate = self;
        cell.ClassificationType = HomePageEmployedassification;
        cell.projectListByModel = self.projectListByModel;
        return cell;
    }else if (indexPath.section == HomePageWikipediaSection){
        XJFEmploymentInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XJFEmploymentInformationCollectionViewCell_ID forIndexPath:indexPath];
        cell.model = self.tablkListModelByArticles.result.data[indexPath.row];
        return cell;
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
    sectionHeaderView.sectionTitle.text = @[@"",@"课程分类",@"从业资讯"][indexPath.section];
    sectionHeaderView.sectionMore.text = @"更多";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapPUSHMorePage:)];
    [sectionHeaderView addGestureRecognizer:tap];
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == HomePageBannerSection) {
        return CGSizeZero;
    }else if (section == HomePageClassificationSection && self.projectListByModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageWikipediaSection && self.tablkListModelByArticles.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }
    return CGSizeZero;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == HomePageBannerSection) {
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == HomePageClassificationSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return KHomePageCollectionByClassificationAndTeacher;
    }else if (indexPath.section == HomePageWikipediaSection){
        _layout.minimumLineSpacing = KMargin;
        return KHomePageCollectionByWikipediaSize;
    }
    
    return CGSizeZero;
}

#pragma mark - sectionHeaderViewTapPUSHMorePage

- (void)sectionHeaderViewTapPUSHMorePage:(UITapGestureRecognizer *)sender
{
    HomePageCollectionSectionHeaderView *sectionHeaderView = (HomePageCollectionSectionHeaderView *)sender.view;
    if ([sectionHeaderView.sectionTitle.text isEqualToString:@"课程分类"]) {

    }else if ([sectionHeaderView.sectionTitle.text isEqualToString:@"从业资讯"]){

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

}


@end
