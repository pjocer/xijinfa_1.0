//
//  TeacherListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherListViewController.h"
#import "IndexConfigure.h"
#import "TeacherDetalPage.h"
#import <MJRefresh.h>
#import "HomePageConfigure.h"

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
        [_collectionView.mj_footer removeFromSuperview];
        [[ZToastManager ShardInstance] showtoast:@"没有更多数据"];
    }
}


#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _layout.itemSize = CGSizeMake((SCREENWITH - 40) / 3, 140);
    
    _layout.minimumLineSpacing = 10.0;
    _layout.minimumInteritemSpacing = 10.0;

    self.collectionView = [[UICollectionView alloc]
            initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10) collectionViewLayout:_layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [_collectionView registerNib:[UINib nibWithNibName:@"XJFTeacherCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID];
    if (!self.collectionView.mj_footer) {
        //mj_footer
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter
                footerWithRefreshingTarget:self
                          refreshingAction:@selector(loadMoreData)];
        self.collectionView.mj_footer.automaticallyHidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count > 0 ? self.dataSource.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFTeacherCollectionViewCell *cell = [collectionView
                                          dequeueReusableCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherDetalPage *teacherDetailViewController = [[TeacherDetalPage alloc] init];
    teacherDetailViewController.teacherListDataModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:teacherDetailViewController animated:YES];
}
@end
