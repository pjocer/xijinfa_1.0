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
    SecuritiesSection, //证券从业
    FundSection,       //基金从业
    FuturesSection     //期货从业
};
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayThumbnailByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;

//证券从业
@property (nonatomic, strong) NSString *employedSecuritiesID;
@property (nonatomic, strong) TablkListModel *securitiesModel;
//期货从业
@property (nonatomic, strong) NSString *employedFuturesID;
@property (nonatomic, strong) TablkListModel *futuresModel;
//基金从业
@property (nonatomic, strong) NSString *employedFundID;
@property (nonatomic, strong) TablkListModel *fundModel;



@end

@implementation HomePageEmployedViewController
#define KEmployedClassificationCellSize CGSizeMake(SCREENWITH - KMargin * 2, 66)
static NSString *EmployedClassificationCell_ID = @"EmployedClassificationCell_ID";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requesProjectListDat:Employed method:GET];
    
}

//ProjectListByModel
- (void)requesProjectListDat:(APIName *)api method:(RequestMethod)method {
    @weakify(self)
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
        
        for (ProjectList *model in self.projectListByModel.result.data) {
            if ([model.title isEqualToString:@"证券从业"]) {
                self.employedSecuritiesID = model.id;
            }
            else if ([model.title isEqualToString:@"期货从业"]) {
                self.employedFuturesID = model.id;
            }
            else if ([model.title isEqualToString:@"基金从业"]) {
                self.employedFundID = model.id;
            }
        }

        [self RequestData];
    } failedBlock:^(NSError *_Nullable error) {
    }];
}

#pragma mark - RequestData

- (void)RequestData {
    RACSignal *requestBannerData = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:appDeptCarousel4 RequestMethod:GET];
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
    
    RACSignal *securitiesSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:[NSString stringWithFormat:@"%@%@", employedCategory, self.employedSecuritiesID] RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.securitiesModel = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.securitiesModel];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    RACSignal *futuresModelSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:[NSString stringWithFormat:@"%@%@", employedCategory, self.employedFuturesID] RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.futuresModel = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.futuresModel];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    RACSignal *fundModelSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:[NSString stringWithFormat:@"%@%@", employedCategory, self.employedFundID] RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.fundModel = [[TablkListModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.fundModel];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUI:securitiesSignal:futuresModel:fundModel:) withSignalsFromArray:@[requestBannerData,securitiesSignal,futuresModelSignal,fundModelSignal]];
}

- (void)updateUI:(BannerModel *)bannerModel
securitiesSignal:(TablkListModel *)securitiesSignal
    futuresModel:(TablkListModel *)futuresModel
       fundModel:(TablkListModel *)fundModel
{
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
    }else if (section == SecuritiesSection){
        return self.securitiesModel.result.data.count > 4 ? 4 : self.securitiesModel.result.data.count;
    }else if (section == FundSection){
        return self.fundModel.result.data.count > 4 ? 4 : self.fundModel.result.data.count;
    }else if (section == FuturesSection){
        return self.futuresModel.result.data.count > 4 ? 4 : self.futuresModel.result.data.count;
    }
    return 0;
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
            cell.model = self.securitiesModel.result.data[indexPath.row];
        }else if (indexPath.section == FundSection){
            cell.model = self.fundModel.result.data[indexPath.row];
        }else if (indexPath.section == FuturesSection){
            cell.model = self.futuresModel.result.data[indexPath.row];
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
    
    if (section == BannerSection || section == ClassificationSection) {
        return CGSizeZero;
    }else if (section == SecuritiesSection && self.securitiesModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == FundSection && self.fundModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == FuturesSection && self.futuresModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }
    return CGSizeZero;
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
    
    if (indexPath.section == SecuritiesSection) {
        TalkGridModel *model = self.securitiesModel.result.data[indexPath.row];
        [self pushPlayerView:model];
    }else if (indexPath.section == FundSection){
        TalkGridModel *model = self.fundModel.result.data[indexPath.row];
        [self pushPlayerView:model];
    }else if (indexPath.section == FuturesSection){
        TalkGridModel *model = self.futuresModel.result.data[indexPath.row];
        [self pushPlayerView:model];
    }
    
    

}

-(void)pushPlayerView:(TalkGridModel *)model
{
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
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
