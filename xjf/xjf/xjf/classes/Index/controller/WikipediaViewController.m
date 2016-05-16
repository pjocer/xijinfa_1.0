//
//  WikipediaViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikipediaViewController.h"
#import "IndexConfigure.h"
#import "WikiPediaCategoriesModel.h"

@interface WikipediaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XRCarouselViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSMutableArray *dataArrayByBanner; /**< 广告数据源 */
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) WikiPediaCategoriesModel *wikiPediaCategoriesModel;
@end

@implementation WikipediaViewController
static NSString * wikiBannerView_HeaderId = @"wikiBannerView_HeaderId";
static NSString * wikiSectionHeaderView_HeaderId = @"wikiSectionHeaderView_HeaderId";
static NSString * talkGridViewCell_Id = @"talkGridViewCell_Id";
static NSString * firstSectionCell_Id = @"firstSectionCell_Id";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self initCollectionView];
    [self requestBannerData:appDeptCarousel2 method:GET];
    [self requestCategoriesData:talkGridCategories method:GET];
}
#pragma mark requestData
- (void)requestBannerData:(APIName *)api method:(RequestMethod)method
{
    __weak typeof (self) wSelf = self;
    self.dataArrayByBanner = [NSMutableArray array];
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    
    //bannermodel
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        
        __strong typeof (self)sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        sSelf.bannermodel = [[BannerModel alloc]initWithData:responseData error:nil];
        for (BannerResultModel *model in sSelf.bannermodel.result.data) {
            [self.dataArrayByBanner addObject:model.thumbnail];
        }
        [sSelf.collectionView reloadData];
        
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
    }];
    
}
- (void)requestCategoriesData:(APIName *)api method:(RequestMethod)method
{
    __weak typeof (self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    
    //Categories
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        
        __strong typeof (self)sSelf = wSelf;
    
        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        sSelf.wikiPediaCategoriesModel = [[WikiPediaCategoriesModel alloc] init];
        [sSelf.wikiPediaCategoriesModel setValuesForKeysWithDictionary:result];
        [sSelf.collectionView reloadData];

    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
    }];
}


#pragma mark -- Navigation
- (void)setNavigation
{
    self.title = @"金融百科";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    
}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    //导航栏右按钮 搜索
}


#pragma mark -- CollectionView
- (void)initCollectionView
{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);//针对分区
        _layout.minimumLineSpacing = 0.0;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0.0;//左右间隔
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10) collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[WikiFirstSectionCell class] forCellWithReuseIdentifier:firstSectionCell_Id];
    [self.collectionView registerClass:[WikiTalkGridViewCell class] forCellWithReuseIdentifier:talkGridViewCell_Id];
    
    //注册header
    [self.collectionView registerClass:[WikiBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:wikiBannerView_HeaderId];
    [self.collectionView registerClass:[WikiSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:wikiSectionHeaderView_HeaderId];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 && self.wikiPediaCategoriesModel.resultModel.dataModelArray != 0) {
        return self.wikiPediaCategoriesModel.resultModel.dataModelArray.count;
    }
    else if (section == 1) {
        return 4;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WikiFirstSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstSectionCell_Id forIndexPath:indexPath];
        if (self.wikiPediaCategoriesModel.resultModel.dataModelArray.count != 0) {
            WikiPediaCategoriesDataModel *model = self.wikiPediaCategoriesModel.resultModel.dataModelArray[indexPath.row];
            cell.label.text = model.name;
        }
        return cell;
    }
        WikiTalkGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:talkGridViewCell_Id forIndexPath:indexPath];
        return cell;
}

/** 头视图 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            WikiBannerView *wikiBannerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:wikiBannerView_HeaderId forIndexPath:indexPath];
            wikiBannerView.carouselView.delegate = self;
            wikiBannerView.carouselView.imageArray = self.dataArrayByBanner;
            
            return wikiBannerView;
        }
        else if (indexPath.section == 1) {
            WikiSectionHeaderView *wikiSectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:wikiSectionHeaderView_HeaderId forIndexPath:indexPath];
            UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
            [wikiSectionHeaderView addGestureRecognizer:singleRecognizer];
            return wikiSectionHeaderView;
        }

    }
    return nil;
}
- (void)handleSingleTapFrom
{
   [self.navigationController pushViewController:[VideolistViewController new] animated:YES];
}
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index
{
    NSLog(@"点击..... %ld",index);
}
/** Header大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(SCREENWITH, 175);
    }
    else if (section == 1) {
          return CGSizeMake(SCREENWITH, 35);
    }
    
    return CGSizeZero;
    
}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[VideolistViewController new] animated:YES];
    }
    else if (indexPath.section == 1) {
        PlayerViewController *player = [[PlayerViewController alloc] init];
        [self.navigationController pushViewController:player animated:YES];
    }
  
}

#pragma mark FlowLayoutDelegate
/** 每个分区item的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _layout.minimumLineSpacing = 0;
        return  CGSizeMake((SCREENWITH - 0)/ 4, 40);
        
        
    }else{
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
}





@end
