//
//  TeacherListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherListViewController.h"
#import "IndexConfigure.h"

@interface TeacherListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, retain) UICollectionViewFlowLayout *layout;
@end

@implementation TeacherListViewController
static NSString *teacherListCell_Id = @"teacherListCell_Id";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"全部老师";
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
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);//针对分区
    _layout.minimumLineSpacing = 1.0;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0.0;//左右间隔

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10) collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[TearcherIndexCell class] forCellWithReuseIdentifier:teacherListCell_Id];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TearcherIndexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:teacherListCell_Id forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark FlowLayoutDelegate

/** 每个分区item的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWITH - 3) / 3, 150);
}


/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


}
@end
