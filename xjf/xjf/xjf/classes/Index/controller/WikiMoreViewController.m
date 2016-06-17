//
//  WikiMoreViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiMoreViewController.h"
#import "WikiMoreClassificationCell.h"
#import "VideolistViewController.h"

@interface WikiMoreViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@end

@implementation WikiMoreViewController
static NSString *WikiMoreCell_Id = @"WikiMoreCell_Id";

+(void)load {
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"析金百科更多";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//针对分区
    _layout.minimumLineSpacing = 10;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0;//左右间隔
    _layout.itemSize = CGSizeMake((SCREENWITH - 40) / 4, 30);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10)
                                             collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[WikiMoreClassificationCell class] forCellWithReuseIdentifier:WikiMoreCell_Id];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)
        indexPath {

    WikiMoreClassificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WikiMoreCell_Id
                                                                                 forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WikiPediaCategoriesDataModel *model = self.dataArray[indexPath.row];
    VideolistViewController *videolistViewController = [VideolistViewController new];
    videolistViewController.ID = model.id;
    videolistViewController.title = model.title;
    [self.navigationController pushViewController:videolistViewController animated:YES];
}


@end
