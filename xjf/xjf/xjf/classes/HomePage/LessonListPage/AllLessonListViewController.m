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

@interface AllLessonListViewController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) SelectedView *selectedView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end

@implementation AllLessonListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
            [self setSelectedView];
            [self initCollectionView];
            if (self.ID) {
                NSString *api = [NSString stringWithFormat:@"%@%@", categoriesVideoList, self.ID];
                [self requesData:api method:GET];
            } else {
                [self requesData:talkGrid method:GET];
            }
        }
            break;
        case LessonListPageSchool: {
            
            [self setSelectedView];
            [self initCollectionView];
            if (self.ID) {
                NSString *api = [NSString stringWithFormat:@"%@%@", coursesProject, self.ID];
                [self requesData:api method:GET];
            } else {
                [self requesData:coursesProjectLessonDetailList method:GET];
            }
        }
            break;
        case LessonListPageEmployed: {
            [self setSelectedView];
            [self initCollectionView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - setControl

#pragma mark  Navigation

- (void)setNavigation {

    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
    self.navigationItem.title = @"析金百科";
        }
            break;
        case LessonListPageSchool: {
    self.navigationItem.title = @"析金学堂";
        }
            break;
        case LessonListPageEmployed: {
    self.navigationItem.title = @"析金从业";
        }
            break;
        default:
            break;
    }
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
    
    _selectedView.leftButtonName = @"Left";
    _selectedView.rightButtonName = @"Right";
    _selectedView.leftTableDataSource = @[@"xxxxx",@"xxaaaaxxxxxbb",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd"].mutableCopy;
    _selectedView.rightTableDataSource = @[@"1",@"2",@"3",@"4",@"5"].mutableCopy;
    _selectedView.handlerData = ^(id data) {
        //reloadData at here.
        NSLog(@"%@",data);
    };
}

- (void)setSelectedViewByEmployedType
{
    self.selectedView = [[SelectedView alloc] initWithFrame:self.view.frame SelectedViewType:ISEmployed];
    [self.view addSubview:_selectedView];
    
    _selectedView.leftButtonName = @"基金从业";
    _selectedView.rightButtonName = @"全科";
    _selectedView.rightTableDataSource = @[@"证卷从业",@"期货从业",@"基金从业"].mutableCopy;
    _selectedView.leftTableDataSource = @[@"基础知识",@"法律法规",@"全科"].mutableCopy;
    _selectedView.handlerData = ^(id data) {
        //reloadData at here.
        NSLog(@"%@",data);
    };
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, KMargin, KMargin);
    _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, _lessonListPageLessonType == LessonListPageWikipedia ? 0 : 35, SCREENWITH, _lessonListPageLessonType == LessonListPageWikipedia ? self.view.frame.size.height - 20:self.view.frame.size.height - 94)
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
    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {

        }
            break;
        case LessonListPageSchool: {

        }
            break;
        case LessonListPageEmployed: {

        }
            break;
        default:
            break;
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.lessonListPageLessonType == LessonListPageWikipedia){
        XJFWikipediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionByWikipedia_CellID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        if (self.lessonListPageLessonType == LessonListPageSchool) {
   
        } else if (self.lessonListPageLessonType == LessonListPageEmployed){
    
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
            TalkGridModel *model = self.dataSource[indexPath.row];
            playerPage.talkGridModel = model;
            playerPage.talkGridListModel = self.tablkListModel;
            [self.navigationController pushViewController:playerPage animated:YES];
        }
            break;
        case LessonListPageSchool: {
            LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
            lessonDetailViewController.model = self.dataSource[indexPath.row];
            lessonDetailViewController.apiType = coursesProjectLessonDetailList;
            [self.navigationController pushViewController:lessonDetailViewController animated:YES];
        }
            break;
        case LessonListPageEmployed: {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark Search

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    //导航栏右按钮 搜索
    SearchViewController *searchViewController = [SearchViewController new];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - handle data
- (void)loadMoreData {
    if (self.tablkListModel.result.next_page_url != nil) {
        [self requesData:_tablkListModel.result.next_page_url method:GET];
    } else if (_tablkListModel.result.current_page == _tablkListModel.result.last_page) {
        
        [_collectionView.mj_footer endRefreshingWithNoMoreData];
           [_collectionView.mj_footer removeFromSuperview];
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
        [self.dataSource addObjectsFromArray:self.tablkListModel.result.data];
        [self.collectionView.mj_footer isRefreshing] ? [self.collectionView.mj_footer endRefreshing] : nil;
        [self.collectionView reloadData];
    } failedBlock:^(NSError *_Nullable error) {
        @strongify(self)
        [self.collectionView.mj_footer isRefreshing] ? [self.collectionView.mj_footer endRefreshing] : nil;
    }];
}


@end
