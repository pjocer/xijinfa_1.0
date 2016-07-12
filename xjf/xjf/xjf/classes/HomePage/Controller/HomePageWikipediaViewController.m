//
//  HomePageWikipediaViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageWikipediaViewController.h"
#import "HomePageConfigure.h"
#import "WikiPediaCategoriesModel.h"

@interface HomePageWikipediaViewController ()<UICollectionViewDataSource,
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
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) WikiPediaCategoriesModel *wikiPediaCategoriesModel;
@end

@implementation HomePageWikipediaViewController

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
    
    RACSignal *talkGridCategoriesSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:talkGridCategories RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.wikiPediaCategoriesModel = [[WikiPediaCategoriesModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:self.wikiPediaCategoriesModel];
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
    
    [self rac_liftSelector:@selector(updateUI:data2:data3:) withSignalsFromArray:@[talkGridCategoriesSignal, requestCategoriesTalkGridData,requestBannerData]];
}

- (void)updateUI:(ProjectListByModel *)data1 data2:(TablkListModel *)data2 data3:(BannerModel *)data3{
    if (data3.result != nil) {
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
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFBigWikipediaCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByWikipediaBig_CellID];
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
        return self.tablkListModel.result.data.count > 8 ? 8 : self.tablkListModel.result.data.count;
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
        cell.ClassificationType = HomePageWikiClassification;
        cell.delegate = self;
        cell.wikiPediaCategoriesModel = self.wikiPediaCategoriesModel;
        return cell;
    }else if (indexPath.section == HomePageWikipediaSection){
        XJFBigWikipediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionByWikipediaBig_CellID forIndexPath:indexPath];
        cell.model = self.tablkListModel.result.data[indexPath.row];
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
    __unsafe_unretained __typeof(sectionHeaderView) weaksectionHeaderView = sectionHeaderView;
    [sectionHeaderView setTitle:@[@"",@"全部分类",@"热门视频"][indexPath.section] moreTitle:@[@"",@"",@"更多"][indexPath.section] moreCallback:^(id gestureRecognizer) {
        if ([weaksectionHeaderView.sectionTitle.text isEqualToString:@"热门视频"]){
            AllLessonListViewController *listViewController = [AllLessonListViewController new];
            listViewController.lessonListPageLessonType = LessonListPageWikipedia;
            listViewController.lessonListTitle = @"热门视频";
            [self.navigationController pushViewController:listViewController animated:YES];
        }
    }];
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == HomePageBannerSection) {
        return CGSizeZero;
    }else if (section == HomePageClassificationSection && self.wikiPediaCategoriesModel.result.data.count > 0){
        return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
    }else if (section == HomePageWikipediaSection && self.tablkListModel.result.data.count > 0){
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
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        return KHomePageCollectionByWikipediaSize;
    }
    
    return CGSizeZero;
}

#pragma mark - delegate

#pragma mark homePageScrollCell didSelectItemAtIndexPath
- (void)homePageScrollCell:(HomePageScrollCell *)homePageScrollCell
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
       ClassificationTitle:(NSString *)title
{
    WikiPediaCategoriesDataModel *model = self.wikiPediaCategoriesModel.result.data[indexPath.row];
    AllLessonListViewController *lessonListViewController = [[AllLessonListViewController alloc] init];
    lessonListViewController.lessonListPageLessonType = LessonListPageWikipedia;
    lessonListViewController.ID = model.id;
    lessonListViewController.lessonListTitle = model.title;
    [self.navigationController pushViewController:lessonListViewController animated:YES];
}

#pragma mark CollectionView DidSelected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HomePageWikipediaSection) {
        PlayerViewController *playerPage = [PlayerViewController new];
        TalkGridModel *model = self.tablkListModel.result.data[indexPath.row];
        playerPage.talkGridModel = model;
        playerPage.talkGridListModel = self.tablkListModel;
        [self.navigationController pushViewController:playerPage animated:YES];
    }
}


@end
