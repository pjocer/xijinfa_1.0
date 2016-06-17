//
//  TeacherListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherListViewController.h"
#import "IndexConfigure.h"
#import "TeacherDetailViewController.h"
#import <MJRefresh.h>

@interface TeacherListViewController () <UICollectionViewDataSource,
        UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataSource;
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requestTeacherData:teacherListHot method:GET];
}

- (void)requestTeacherData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    //TeacherListHostModel
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.hostModel = [[TeacherListHostModel alloc] initWithData:responseData error:nil];
        [sSelf.dataSource addObjectsFromArray:sSelf.hostModel.result.data];
        [sSelf.collectionView.mj_footer isRefreshing] ? [sSelf.collectionView.mj_footer endRefreshing] : nil;
        [sSelf.collectionView reloadData];
        [[ZToastManager ShardInstance] hideprogress];
    }                  failedBlock:^(NSError *_Nullable error) {
        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [sSelf.collectionView.mj_footer isRefreshing] ? [sSelf.collectionView.mj_footer endRefreshing] : nil;
    }];
}

- (void)loadMoreData {
    if (self.hostModel.result.next_page_url != nil) {
        [self requestTeacherData:self.hostModel.result.next_page_url method:GET];
    } else if (self.hostModel.result.current_page == self.hostModel.result.last_page) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
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

    [self.collectionView registerClass:[TearcherIndexCell class]
            forCellWithReuseIdentifier:teacherListCell_Id];
    if (!self.collectionView.mj_footer) {
        //mj_footer
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter
                footerWithRefreshingTarget:self
                          refreshingAction:@selector(loadMoreData)];
        self.collectionView.mj_footer.automaticallyHidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TearcherIndexCell *cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:teacherListCell_Id forIndexPath:indexPath];
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
