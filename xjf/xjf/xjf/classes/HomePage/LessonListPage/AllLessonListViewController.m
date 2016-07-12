//
//  AllLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AllLessonListViewController.h"
#import "SearchViewController.h"
#import "HomePageConfigure.h"
#import "SelectedView.h"
#import <MJRefresh.h>
#import "LessonPlayerViewController.h"
#import "EmployedbundleListPage.h"

@interface AllLessonListViewController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) SelectedView *selectedView;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AllLessonListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.isFavoredsList = NO;
        self.isMyLessonsList = NO;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
            [self initCollectionView];
            if (self.ID) {
                NSString *api = [NSString stringWithFormat:@"%@%@", categoriesVideoList, self.ID];
                [self requesData:api method:GET];
            }else if (_isFavoredsList == YES){
                [self requesData:favorite method:GET];
            }else {
                [self requesData:talkGrid method:GET];
            }
        }
            break;
        case LessonListPageSchool: {
            if (self.ID) {
                [self setSelectedView];
                [self initCollectionView];
                NSString *api = [NSString stringWithFormat:@"%@%@", coursesProject, self.ID];
                [self requesData:api method:GET];
            }else if (_isFavoredsList == YES){
                [self initCollectionView];
                [self requesData:favorite method:GET];
            }else if (_isMyLessonsList == YES){
                [self initCollectionView];
                [self requesData:myLessonsApi method:GET];
            }
            else {
                [self setSelectedView];
                [self initCollectionView];
                [self requesData:coursesProjectLessonDetailList method:GET];
            }
        }
            break;
        case LessonListPageEmployed: {

            if (_isFavoredsList == YES){
                [self initCollectionView];
                [self requesData:favorite method:GET];
            }else if (_isMyLessonsList == YES){
                [self initCollectionView];
                [self requesData:myLessonsApi method:GET];
            }else {
                [self setSelectedView];
                [self initCollectionView];
                [self requesData:contents method:GET];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - setControl

#pragma mark  Navigation

- (void)setNavigation {

    self.navigationItem.title = self.lessonListTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"search"]
                                              style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
}

#pragma mark SelectedView

- (void)setSelectedView
{
    if (self.lessonListPageLessonType == LessonListPageSchool) {
        [self setSelectedViewBySchoolType];
    } else if (self.lessonListPageLessonType == LessonListPageEmployed){
        [self setSelectedViewByEmployedType];
    }

}

- (void)setSelectedViewBySchoolType
{
    self.selectedView = [[SelectedView alloc] initWithFrame:self.view.frame SelectedViewType:ISSchool];
    [self.view addSubview:_selectedView];
    
    _selectedView.leftButtonName = @"综合排序";
    _selectedView.rightButtonName = @"筛选";
//    _selectedView.leftTableDataSource = @[@"综合排序",@"销量最好",@"价格由低到高",@"价格由高到低"].mutableCopy;
//    _selectedView.rightTableDataSource = @[@"学习内容",@"当前水平",@"析金名师"].mutableCopy;
    @weakify(self)
    _selectedView.handlerData = ^(id data) {
        @strongify(self)
        NSLog(@"%@",data);

    };
}

- (void)setSelectedViewByEmployedType
{
    self.selectedView = [[SelectedView alloc] initWithFrame:self.view.frame SelectedViewType:ISEmployed];
    [self.view addSubview:_selectedView];

    _selectedView.leftButtonName = @"全部";
    _selectedView.rightButtonName = @"全部";
    [self requestEmployedData];
    
    //reloadData at here.
    @weakify(self)
    _selectedView.handlerData = ^(id data) {
        @strongify(self)
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        if ([data isEqualToString:@"全部"]) {
            self.collectionView.mj_footer.hidden = NO;
            [self requesData:contents method:GET];
        }else{
           [self requesData:[NSString stringWithFormat:@"%@%@", test, data] method:GET];
        }
    };

}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, KMargin, KMargin);
    _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, _selectedView ? 35 : 0, SCREENWITH, _selectedView ? self.view.frame.size.height - 94:self.view.frame.size.height - 20)
                           collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

    [_collectionView registerNib:[UINib nibWithNibName:@"XJFWikipediaCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByWikipedia_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    
    if (!_collectionView.mj_footer) {
        //mj_footer
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    }
}

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.lessonListPageLessonType == LessonListPageWikipedia){
        XJFWikipediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionByWikipedia_CellID forIndexPath:indexPath];
        cell.model = _dataSource[indexPath.row];
        return cell;
    }else{
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        cell.model = _dataSource[indexPath.row];
        if (self.isFavoredsList == NO && self.isMyLessonsList == NO) {
            cell.priceBackGroudView.hidden = NO;
        }else{
            cell.priceBackGroudView.hidden = YES;
        }
        return cell;
    }
    
    return nil;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return KHomePageCollectionByLessons;
}


#pragma mark - Actions

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
            PlayerViewController *playerPage = [PlayerViewController new];
            TalkGridModel *model = _dataSource[indexPath.row];
            playerPage.talkGridModel = model;
            playerPage.talkGridListModel = self.tablkListModel;
            [self.navigationController pushViewController:playerPage animated:YES];
        }
            break;
        case LessonListPageSchool: {
            TalkGridModel *model = _dataSource[indexPath.row];
            [self pushLessonPlayerPage:model];
        }
            break;
        case LessonListPageEmployed: {
            TalkGridModel *model = _dataSource[indexPath.row];
            [self pushLessonPlayerPage:model];
        }
            break;
        default:
            break;
    }
}

- (void)pushLessonPlayerPage:(TalkGridModel *)model{
    if ([model.type isEqualToString:@"bundle"]) {
        EmployedbundleListPage *employedbundleListPage = [EmployedbundleListPage new];
        employedbundleListPage.api_uri = model.api_uri;
        employedbundleListPage.navigationItem.title = model.title;
        [self.navigationController pushViewController:employedbundleListPage animated:YES];
        
    }else if ([model.type isEqualToString:@"course"]){
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    }
}

#pragma mark Search

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    SearchViewController *searchViewController = [SearchViewController new];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - handle data

///loadMoreData
- (void)loadMoreData {
    if (self.tablkListModel.result.next_page_url != nil) {
        [self requesData:_tablkListModel.result.next_page_url method:GET];
    } else if (_tablkListModel.result.current_page == _tablkListModel.result.last_page) {
        
        [_collectionView.mj_footer endRefreshingWithNoMoreData];
           _collectionView.mj_footer.hidden = YES;
           [[ZToastManager ShardInstance] showtoast:@"没有更多数据"];
    }
}


#pragma mark requestData

- (void)requesData:(APIName *)api method:(RequestMethod)method {
    
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
       @strongify(self)
        self.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        if (self.tablkListModel.errCode==0) {
            if (_isFavoredsList == YES) {
                [self handleDataByTypeIfIsFavoredsList];
            }else if (_isMyLessonsList == YES) {
                [self handleDataIfIsMyLessonsList];
            }else{
                [_dataSource addObjectsFromArray:self.tablkListModel.result.data];
            }
            [self.collectionView.mj_footer isRefreshing] ? [self.collectionView.mj_footer endRefreshing] : nil;
            [self.collectionView reloadData];
    
        }else {
            [[ZToastManager ShardInstance] showtoast:self.tablkListModel.errMsg];
        }
    } failedBlock:^(NSError *_Nullable error) {
        @strongify(self)
        [self.collectionView.mj_footer isRefreshing] ? [self.collectionView.mj_footer endRefreshing] : nil;
    }];
}

#pragma mark handleDataIfIsMyLessonsList

- (void)handleDataIfIsMyLessonsList{
    
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
        }
            break;
        case LessonListPageSchool: {
            for (TalkGridModel *tempmodel in self.tablkListModel.result.data) {
                if ([tempmodel.department isEqualToString:@"dept3"]) {
                    [self.dataSource addObject:tempmodel];
                }
            }
        }
            break;
        case LessonListPageEmployed: {
            for (TalkGridModel *tempmodel in self.tablkListModel.result.data) {
                if ([tempmodel.department isEqualToString:@"dept4"]) {
                    [self.dataSource addObject:tempmodel];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark handleDataByTypeIfIsFavoredsList

- (void)handleDataByTypeIfIsFavoredsList{
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
            [self handleDataByDeptType:@"dept2"];
        }
            break;
        case LessonListPageSchool: {
            [self handleDataByDeptType:@"dept3"];
        }
            break;
        case LessonListPageEmployed: {
            [self handleDataByDeptType:@"dept4"];
        }
            break;
        default:
            break;
    }
}

- (void)handleDataByDeptType:(NSString *)str
{
    for (TalkGridModel *model in self.tablkListModel.result.data) {
        if ([model.type isEqualToString:@"course"] && [model.department isEqualToString:str]) {
            [self.dataSource addObject:model];
        }
    }
}

#pragma mark requestEmployedData(从业筛选数据)

- (void)requestEmployedData{
    RACSignal *projectListByModelSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:Employed RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            ProjectListByModel *tempModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
            [subscriber sendNext:tempModel];
        }failedBlock:^(NSError *_Nullable error) {
        }];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(update:) withSignalsFromArray:@[projectListByModelSignal]];
}

- (void)update:(ProjectListByModel *)model{
    self.selectedView.projectListByModel_Employed = model;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (ProjectList *tempModel in model.result.data) {
        NSMutableArray *smallArray = [NSMutableArray array];
        for (ProjectList *childrenModel in tempModel.children) {
            [smallArray addObject:childrenModel.title];
        }
        [smallArray addObject:@"全部"];
         [tempDic setValue:smallArray forKey:tempModel.title];
    }
     [tempDic setValue:@[@"全部"] forKey:@"全部"];
    self.selectedView.employedDataDic = tempDic;
}

@end
