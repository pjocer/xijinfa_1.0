//
//  SearchViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchSectionOne.h"
#import "XJMarket.h"
#import "TalkGridModel.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import "SearchSectionTwo.h"
#import "SearchResultController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, TableViewRefreshDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SearchSectionOne *cell;
@property (nonatomic, strong) TablkListModel *model;
@property (nonatomic, strong) SearchResultController *result;
@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView {
    [super loadView];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 64)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView addShadow];
    [searchView addSubview:self.searchBar];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.frame = CGRectMake(SCREENWITH - 40, 27, 30, 30);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
    cancel.titleLabel.font = FONT15;
    [cancel addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancel];
    [self.view addSubview:searchView];
    [self.view addSubview:self.tableView];
    self.dataSource = [NSMutableArray array];
    [self requestData:coursesProjectLessonDetailList Method:GET type:UnKnownType];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWITH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SearchSectionOne class] forCellReuseIdentifier:@"SearchSectionOne"];
        [_tableView registerNib:[UINib nibWithNibName:@"SearchSectionTwo" bundle:nil] forCellReuseIdentifier:@"SearchSectionTwo"];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 27, SCREENWITH - 60, 30)];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.placeholder = @"输入你想找的内容";
        _searchBar.returnKeyType = UIReturnKeySearch;
        UITextField *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        searchTextField.backgroundColor = BackgroundColor;
        searchTextField.textColor = NormalColor;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSectionOne"];
        [_cell initSubViews];
        @weakify(self);
        _cell.SearchHandler = ^(NSString *text) {
            @strongify(self);
            self.searchBar.text = text;
        };
        return _cell;
    } else {
        SearchSectionTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSectionTwo" forIndexPath:indexPath];
        TalkGridModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? _cell.cellHeight : 101;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerView:section];
}

#pragma mark - Assist Method

- (UIView *)headerView:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    UILabel *top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 1)];
    top.backgroundColor = BackgroundColor;
    [header addSubview:top];
    UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    bottom.backgroundColor = BackgroundColor;
    [header addSubview:bottom];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 18)];
    title.font = FONT15;
    title.textColor = NormalColor;
    title.text = section == 0 ? @"最近搜索" : @"热门推荐";
    [header addSubview:title];
    if (section == 0) {
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
        [delete setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        delete.frame = CGRectMake(SCREENWITH - 30, 8, 20, 20);
        [delete addTarget:self action:@selector(deleteRencentlySearch) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:delete];
    }
    return header;
}

- (void)requestData:(APIName *)api Method:(RequestMethod)method type:(ReloadTableType)type {
    if (api == nil) {
        [_result hiddenMJRefresh];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        [self handleRequestData:responseData api:api type:type];
        if (type != UnKnownType) {
            [_result hiddenMJRefresh];
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [_result hiddenMJRefresh];
    }];
}

- (void)handleRequestData:(NSData *_Nullable)data api:(APIName *)api type:(ReloadTableType)type {
    if (type == UnKnownType) {
        self.model = [[TablkListModel alloc] initWithData:data error:nil];
        if (self.model.errCode == 0) {
            [self.dataSource addObjectsFromArray:self.model.result.data];
            [self.tableView reloadData];
        } else {
            [[ZToastManager ShardInstance] showtoast:self.model.errMsg];
        }
    } else if (type == EncyclopediaTable) {
        _result.baike_list = [[TablkListModel alloc] initWithData:data error:nil];
        if (_result.baike_list.errCode == 0 && _result.baike_list.result.data.count > 0) {
            [_result.encyDataSource addObjectsFromArray:_result.baike_list.result.data];
            [_result reloadData:EncyclopediaTable];
        } else {
            [[ZToastManager ShardInstance] showtoast:_result.baike_list.errMsg];
        }
    } else if (type == LessonsTable) {
        _result.lesson_list = [[TablkListModel alloc] initWithData:data error:nil];
        if (_result.lesson_list.errCode == 0 && _result.lesson_list.result.data) {
            [_result.lessonsDataSource addObjectsFromArray:_result.lesson_list.result.data];
            [_result reloadData:LessonsTable];
        } else {
            [[ZToastManager ShardInstance] showtoast:_result.baike_list.errMsg];
        }
    } else if (type == TopicsTable) {
        _result.topic_list = [[TopicModel alloc] initWithData:data error:nil];
        if (_result.topic_list.errCode == 0 && _result.topic_list.result.data) {
            [_result.topicsDataSource addObjectsFromArray:_result.topic_list.result.data];
            [_result reloadData:TopicsTable];
        } else {
            [[ZToastManager ShardInstance] showtoast:_result.topic_list.errMsg];
        }
    } else if (type == PersonsTable) {
        _result.person_list = [[FansFocus alloc] initWithData:data error:nil];
        if (_result.person_list.errCode.integerValue == 0 && _result.person_list.result.data) {
            [_result.personsDataSource addObjectsFromArray:_result.person_list.result.data];
            [_result reloadData:PersonsTable];
        } else {
            [[ZToastManager ShardInstance] showtoast:_result.person_list.errMsg];
        }
    }
}

- (void)initDataResult {
    [self requestData:[NSString stringWithFormat:@"%@%@", search_baike, self.searchBar.text] Method:GET type:EncyclopediaTable];
    [self requestData:[NSString stringWithFormat:@"%@%@", search_topic, self.searchBar.text] Method:GET type:TopicsTable];
    [self requestData:[NSString stringWithFormat:@"%@%@", search_lesson, self.searchBar.text] Method:GET type:LessonsTable];
    [self requestData:[NSString stringWithFormat:@"%@%@", search_person, self.searchBar.text] Method:GET type:PersonsTable];
}

- (void)initResult {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    _result = [[SearchResultController alloc] init];
    _result.delegate = self;
    [self RACHandle];
    [self initDataResult];
    UIView *resultView = _result.view;
    resultView.frame = CGRectMake(0, 64, SCREENWITH, SCREENHEIGHT - 64);
    [self.view addSubview:resultView];
}

- (void)RACHandle {
    [[self rac_signalForSelector:@selector(tableViewHeaderDidRefresh) fromProtocol:@protocol(TableViewRefreshDelegate)] subscribeNext:^(RACTuple *x) {
        [self requestData:[NSString stringWithFormat:@"%@%@", _result.api, self.searchBar.text] Method:GET type:_result.type];
    }];
    [[self rac_signalForSelector:@selector(tableViewFooterDidRefresh:) fromProtocol:@protocol(TableViewRefreshDelegate)] subscribeNext:^(RACTuple *x) {
        [self requestData:(NSString *) x.first Method:GET type:_result.type];
    }];
}

#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text replaceNullString] != nil) {
        if (_result == nil) {
            [self initResult];
        } else {
            [_result clearDataSource];
            [self requestData:[NSString stringWithFormat:@"%@%@", _result.api, self.searchBar.text] Method:GET type:_result.type];
        }
        [searchBar resignFirstResponder];
        [[XJMarket sharedMarket] addSearch:searchBar.text];
    }
}

#pragma mark - Action

- (void)deleteRencentlySearch {
    [[XJMarket sharedMarket] clearRecentlySearched];
    [self.tableView reloadData];
}

- (void)cancelSearchAction {
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
