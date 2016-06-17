//
//  MyTeacherViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyTeacherViewController.h"
#import "TeacherDetailViewController.h"
#import "TearcherIndexCell.h"
#import "TeacherListHostModel.h"

@interface MyTeacherViewController () <UICollectionViewDataSource,
        UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) TeacherListHostModel *teacherListHostModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyTeacherViewController
static NSString *myTeacherListCell_Id = @"myTeacherListCell_Id";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"我的老师";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requestCategoriesTalkGridData:favorite method:GET];
}

- (void)requestCategoriesTalkGridData:(APIName *)talkGridApi
                               method:(RequestMethod)method {
    self.dataSource = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:talkGridApi RequestMethod:method];
    //TalkGridData
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.teacherListHostModel = [[TeacherListHostModel alloc] initWithData:responseData error:nil];

        for (TeacherListData *model in self.teacherListHostModel.result.data) {
            if ([model.type isEqualToString:@"guru"]) {
                [self.dataSource addObject:model];
            }
        }
        [sSelf.collectionView reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);//针对分区
    _layout.minimumLineSpacing = 1.0;   //最小列间距默认10
    _layout.minimumInteritemSpacing = 0.0;//左右间隔

    self.collectionView = [[UICollectionView alloc]
            initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10) collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[TearcherIndexCell class] forCellWithReuseIdentifier:myTeacherListCell_Id];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TearcherIndexCell *cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:myTeacherListCell_Id forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark FlowLayoutDelegate

/** 每个分区item的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWITH - 3) / 3, 150);
}


/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherDetailViewController *teacherDetailViewController = [[TeacherDetailViewController alloc] init];
    teacherDetailViewController.teacherListDataModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:teacherDetailViewController animated:YES];

}

@end
