//
//  HomePageEmployedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageEmployedViewController.h"
#import "HomePageConfigure.h"
#import "EmployedClassificationCollectionViewCell.h"
#import "EmploymentInformationViewController.h"
#import "AllLessonListViewController.h"
#import "GuideViewController.h"
#import "TestTimeViewController.h"

@interface HomePageEmployedViewController ()<UICollectionViewDataSource,
                                                    UICollectionViewDelegate,
                                                    UICollectionViewDelegateFlowLayout,
                                                    EmployedClassificationCellDelegate>

typedef NS_OPTIONS(NSInteger, WikipediaControllerSectionType) {
    BannerSection = 0,
    ClassificationSection,
    SecuritiesSection,
    FundSection,
    FuturesSection
};
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayThumbnailByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@end

@implementation HomePageEmployedViewController
#define KEmployedClassificationCellSize CGSizeMake(SCREENWITH - KMargin * 2, 66)
static NSString *EmployedClassificationCell_ID = @"EmployedClassificationCell_ID";


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
    
//    RACSignal *articlesSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
//        @weakify(self)
//        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Articles RequestMethod:GET];
//        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
//            @strongify(self)
//            self.tablkListModelByArticles = [[TablkListModel alloc] initWithData:responseData error:nil];
//            [subscriber sendNext:self.tablkListModelByArticles];
//        }failedBlock:^(NSError *_Nullable error) {
//        }];
//        return nil;
//    }];
//
//    RACSignal *ProjectListDat = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
//        @weakify(self)
//        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Employed RequestMethod:GET];
//        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
//            @strongify(self)
//            self.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
//            [subscriber sendNext:self.projectListByModel];
//        }failedBlock:^(NSError *_Nullable error) {
//        }];
//        return nil;
//    }];
    
    [self rac_liftSelector:@selector(updateUI:) withSignalsFromArray:@[requestBannerData]];
}

- (void)updateUI:(BannerModel *)bannerModel{
    if (bannerModel.result != nil) {
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
    _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
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
    

    [_collectionView registerClass:[HomePageBanderCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerBander_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"EmployedClassificationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:EmployedClassificationCell_ID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    
    [_collectionView registerClass:[HomePageCollectionSectionHeaderView class]
        forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == BannerSection || section == ClassificationSection) {
        return 1;
    }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BannerSection) {
        HomePageBanderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
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
    }else if (indexPath.section == ClassificationSection){
        EmployedClassificationCollectionViewCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    EmployedClassificationCell_ID
                                    forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else {
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        if (indexPath.section == SecuritiesSection) {
            
        }else if (indexPath.section == FundSection){
            
        }else if (indexPath.section == FuturesSection){
            
        }
        return cell;
    }
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCollectionSectionHeaderView *sectionHeaderView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
     HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    sectionHeaderView.sectionTitle.text = @[@"",@"",@"证卷从业",@"基金从业",@"期货从业"][indexPath.section];
    sectionHeaderView.sectionMore.text = @"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapPUSHMorePage:)];
    [sectionHeaderView addGestureRecognizer:tap];
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
//    if (section == BannerSection || section == ClassificationSection) {
//        return CGSizeZero;
//    }else if (section == SecuritiesSection && self.projectListByModel.result.data.count > 0){
//        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
//    }else if (section == FundSection && self.tablkListModelByArticles.result.data.count > 0){
//        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
//    }else if (section == FuturesSection && self.tablkListModelByArticles.result.data.count > 0){
//        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
//    }
//    return CGSizeZero;
    if (section == BannerSection || section == ClassificationSection) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == BannerSection) {
        _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == ClassificationSection){
        _layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, 0, KMargin);
        return KEmployedClassificationCellSize;
    }
    
    if (indexPath.section == FuturesSection) {
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
    return KHomePageCollectionByLessons;
}

#pragma mark - sectionHeaderViewTapPUSHMorePage

- (void)sectionHeaderViewTapPUSHMorePage:(UITapGestureRecognizer *)sender
{
    HomePageCollectionSectionHeaderView *sectionHeaderView = (HomePageCollectionSectionHeaderView *)sender.view;
    if ([sectionHeaderView.sectionTitle.text isEqualToString:@"证卷从业"]) {

    }else if ([sectionHeaderView.sectionTitle.text isEqualToString:@"基金从业"]){

    }else if ([sectionHeaderView.sectionTitle.text isEqualToString:@"期货从业"]){
        
    }
}

#pragma mark - delegate

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark employedClassificationCollectionViewCell didSelectButton

- (void)employedClassificationCollectionViewCell:(EmployedClassificationCollectionViewCell *)Cell didSelectButton:(UIButton *)button
{
    switch (button.tag) {
        case DeiveFromButton: {
            AllLessonListViewController *listViewController = [AllLessonListViewController new];
            listViewController.lessonListPageLessonType = LessonListPageEmployed;
            [self.navigationController pushViewController:listViewController animated:YES];
        }
            break;
        case DeiveFileButton: {
            EmploymentInformationViewController *employmentInformationViewController = [EmploymentInformationViewController new];
            [self.navigationController pushViewController:employmentInformationViewController animated:YES];
        }
            break;
        case BookButton: {
            GuideViewController *guideViewController = [GuideViewController new];
            [self.navigationController pushViewController:guideViewController animated:YES];
        }
            break;
        case TodayButton: {
            TestTimeViewController *testTimeViewController = [TestTimeViewController new];
            [self.navigationController pushViewController:testTimeViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
