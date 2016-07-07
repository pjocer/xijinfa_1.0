//
//  EmploymentInformationViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmploymentInformationViewController.h"
#import "HomePageConfigure.h"

@interface EmploymentInformationViewController ()<UICollectionViewDataSource,
                                                        UICollectionViewDelegate,
                                                        UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) TablkListModel *tablkListModelByArticles;
@end

@implementation EmploymentInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"从业资讯";
    [self initCollectionView];
    [self RequestData];
}


#pragma mark - RequestData

- (void)RequestData {
        @weakify(self)
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Articles RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.tablkListModelByArticles = [[TablkListModel alloc] initWithData:responseData error:nil];
            [self.collectionView reloadData];
        }failedBlock:^(NSError *_Nullable error) {
        }];
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = KHomePageCollectionByWikipediaSize;
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _layout.minimumLineSpacing = KMargin;
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - KMargin - KMargin)
                           collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFEmploymentInformationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:XJFEmploymentInformationCollectionViewCell_ID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tablkListModelByArticles.result.data.count > 0 ? self.tablkListModelByArticles.result.data.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFEmploymentInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XJFEmploymentInformationCollectionViewCell_ID forIndexPath:indexPath];
    cell.model = self.tablkListModelByArticles.result.data[indexPath.row];
    return cell;
}

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
