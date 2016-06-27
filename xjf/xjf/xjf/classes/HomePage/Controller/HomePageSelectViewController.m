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
                                            XRCarouselViewDelegate,
                                            HomePageScrollCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayByBanner;
@property (nonatomic, strong) BannerModel *bannermodel;
@end

@implementation HomePageSelectViewController
static NSString *HomePageSelectViewControllerText_Cell = @"HomePageSelectViewControllerText_Cell";
static NSString *HomePageSelectViewControllerBander_CellID = @"HomePageSelectViewControllerBander_CellID";
static NSString *HomePageSelectViewControllerHomePageScrollCell_CellID = @"HomePageSelectViewControllerHomePageScrollCell_CellID";
static NSString *HomePageSelectViewControllerSeccontionHeader_identfail = @"HomePageSelectViewControllerSeccontionHeader_identfail";

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
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerText_Cell];
     [self.collectionView registerClass:[HomePageBanderCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerBander_CellID];
    [self.collectionView registerClass:[HomePageScrollCell class] forCellWithReuseIdentifier:HomePageSelectViewControllerHomePageScrollCell_CellID];
    
    [self.collectionView registerClass:[HomePageCollectionSectionHeaderView class]
            forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
//        return self.teacherListHostModel.result.data.count > 3 ? 3 : self.teacherListHostModel.result.data.count;
        return 4;
    }else if (section == 2) {
        //        return self.teacherListHostModel.result.data.count > 3 ? 3 : self.teacherListHostModel.result.data.count;
        return 4;
    }else if (section == 3) {
        //        return self.teacherListHostModel.result.data.count > 3 ? 3 : self.teacherListHostModel.result.data.count;
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePageBanderCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerBander_CellID
                                    forIndexPath:indexPath];
        cell.carouselView.delegate = self;
        cell.carouselView.backgroundColor = [UIColor redColor];
        return cell;
    }else if (indexPath.section == 1){
//        MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageWikipediaCell_IDTest forIndexPath:indexPath];
//        return cell;
    }else if (indexPath.section == 2){
//        TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TestCell_IDTWO forIndexPath:indexPath];
//        return cell;
    }else if (indexPath.section == 3){
        HomePageScrollCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerHomePageScrollCell_CellID
                                    forIndexPath:indexPath];
        cell.cellType = ClassificationCell;
        cell.delegate = self;
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:
                                    HomePageSelectViewControllerText_Cell
                                    forIndexPath:indexPath];

    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCollectionSectionHeaderView *sectionHeaderView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
     HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    sectionHeaderView.sectionTitle.text = @[@"",@"析金百科",@"析金学堂",@"析金从业"][indexPath.section];
    sectionHeaderView.SectionMore.text = @"更多";
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
}
#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return KHomePageCollectionByBannerSize;
    }else if (indexPath.section == 1){
        _layout.minimumInteritemSpacing =KlayoutMinimumLineSpacing;
        _layout.minimumLineSpacing = KlayoutMinimumInteritemSpacing;
        return KHomePageCollectionByClassificationAndTeacher;
    }else if (indexPath.section == 2){
        return KHomePageCollectionByClassificationAndTeacher;
    }else if (indexPath.section == 3){
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return KHomePageCollectionByLessons;
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
