//
//  HomePageWikipediaViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageWikipediaViewController.h"
#import "HomePageConfigure.h"

@interface HomePageWikipediaViewController ()<UICollectionViewDataSource,
                                                    UICollectionViewDelegate,
                                                    UICollectionViewDelegateFlowLayout,
                                                    XRCarouselViewDelegate,
                                                    HomePageScrollCellDelegate>

typedef NS_OPTIONS(NSInteger, WikipediaControllerSectionType) {
    HomePageBannerSection = 0,
    HomePageClassificationSection,
    HomePageWikipediaSection
};

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@end

@implementation HomePageWikipediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
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
        //        return self.teacherListHostModel.result.data.count > 3 ? 3 : self.teacherListHostModel.result.data.count;
        return 1;
    }else if (section == HomePageWikipediaSection) {
        //        return self.teacherListHostModel.result.data.count > 3 ? 3 : self.teacherListHostModel.result.data.count;
        return 4;
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
        cell.carouselView.delegate = self;
        return cell;
    }else if (indexPath.section == HomePageClassificationSection){
        HomePageScrollCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerHomePageScrollCell_CellID
                                    forIndexPath:indexPath];
        cell.cellType = ClassificationCell;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == HomePageWikipediaSection){
        XJFBigWikipediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionByWikipediaBig_CellID forIndexPath:indexPath];
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
    sectionHeaderView.sectionTitle.text = @[@"",@"全部分类",@"析金百科"][indexPath.section];
    sectionHeaderView.SectionMore.text = @"更多";
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == HomePageBannerSection) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == HomePageBannerSection) {
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == HomePageClassificationSection){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return KHomePageCollectionByLessons;
    }else if (indexPath.section == HomePageWikipediaSection){
        _layout.minimumLineSpacing = 10.0;
        return KHomePageCollectionByWikipediaSize;
    }
    
    return CGSizeZero;
}

#pragma mark - delegate

#pragma mark homePageScrollCell didSelectItemAtIndexPath
- (void)homePageScrollCell:(HomePageScrollCell *)homePageScrollCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark carouselView didClickImage
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index
{
    
}

#pragma mark CollectionView DidSelected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    //        if ([[XJAccountManager defaultManager] accessToken] == nil ||
    //            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
    //            [self LoginPrompt];
    //        } else {
    //            LessonListViewController *lessonListViewController = [LessonListViewController new];
    //            ProjectList *model = self.projectListByModel.result.data[indexPath.row];;
    //            lessonListViewController.LessonListTitle = model.title;
    //            lessonListViewController.ID = model.id;
    //            [self.navigationController pushViewController:lessonListViewController animated:YES];
    //        }
    //    }
    //    else if (indexPath.section == 1) {
    //        TeacherDetailViewController *teacherDetailViewController = [[TeacherDetailViewController alloc] init];
    //        teacherDetailViewController.teacherListDataModel = self.teacherListHostModel.result.data[indexPath.row];
    //        [self.navigationController pushViewController:teacherDetailViewController animated:YES];
    //    }
}


@end
