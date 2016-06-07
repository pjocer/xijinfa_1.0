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
@interface SearchViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SearchSectionOne *cell;
@property (nonatomic, strong) TablkListModel *model;
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadView {
    [super loadView];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 64)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView addShadow];
    [searchView addSubview:self.searchBar];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.frame = CGRectMake(SCREENWITH-40, 27, 30, 30);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
    cancel.titleLabel.font = FONT15;
    [cancel addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancel];
    [self.view addSubview:searchView];
    [self.view addSubview:self.tableView];
    self.dataSource = [NSMutableArray array];
    [self requestData:coursesProjectLessonDetailList Method:GET];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWITH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SearchSectionOne class] forCellReuseIdentifier:@"SearchSectionOne"];
        [_tableView registerNib:[UINib nibWithNibName:@"SearchSectionTwo" bundle:nil] forCellReuseIdentifier:@"SearchSectionTwo"];
    }
    return _tableView;
}
-(UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 27, SCREENWITH-60, 30)];
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
    return section==0?1:self.dataSource.count;
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
    }else {
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
    return indexPath.section==0?_cell.cellHeight:101;
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
    title.text = section==0?@"最近搜索":@"热门推荐";
    [header addSubview:title];
    if (section == 0) {
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
        [delete setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        delete.frame = CGRectMake(SCREENWITH-30, 8, 20, 20);
        [delete addTarget:self action:@selector(deleteRencentlySearch) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:delete];
    }
    return header;
}
- (void)requestData:(APIName *)api Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        self.model = [[TablkListModel alloc] initWithData:responseData error:nil];
        if (self.model.errCode == 0) {
            [self.dataSource addObjectsFromArray:self.model.result.data];
            [self.tableView reloadData];
        }else {
            [[ZToastManager ShardInstance] showtoast:self.model.errMsg];
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}
- (void)handleResult{
    SearchResultController *result = [[SearchResultController alloc] init];
    UIView *resultView = result.view;
    resultView.frame = CGRectMake(0, 64, SCREENWITH, SCREENHEIGHT-64);
    [self.view addSubview:resultView];
    NSLog(@"%ld",result.current);
}
#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text replaceNullString] != nil) {
        [searchBar resignFirstResponder];
        [[XJMarket sharedMarket] addSearch:searchBar.text];
        [self.tableView removeFromSuperview];
        [self handleResult];
    }
}
#pragma mark - Action
- (void)deleteRencentlySearch {
    [[XJMarket sharedMarket] clearRecentlySearched];
    [self.tableView reloadData];
}
- (void)cancelSearchAction{
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
