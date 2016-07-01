//
//  MyCommentViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/3.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentViewController.h"
#import "XJAccountManager.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import <MJRefresh/MJRefresh.h>
#import "CommentCell.h"
#import "TopicDetailViewController.h"
#import "TopicDetailModel.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TopicModel *model;
@property (nonatomic, strong) UserInfoModel *user;
@end

@implementation CommentViewController
- (instancetype)initWith:(UserInfoModel *)user {
    if (self == [super init]) {

        _user = user;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

- (void)initMainUI {
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self requestData:[NSString stringWithFormat:user_comment_list, self.user.id] Method:GET];
    self.nav_title = [NSString stringWithFormat:@"%@的回答", [_user.id isEqualToString:[[XJAccountManager defaultManager] user_id]] ? @"我" : _user.nickname];
}

- (void)requestData:(APIName *)api Method:(RequestMethod)method {
    if (api == nil) {
        [self hiddenMJRefresh:self.tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        self.model = [[TopicModel alloc] initWithData:responseData error:nil];
        if (self.model.errCode == 0) {
            [self.dataSource addObjectsFromArray:self.model.result.data.count > 0 ? self.model.result.data : nil];
            [self.tableView reloadData];
        } else {
            [[ZToastManager ShardInstance] showtoast:self.model.errMsg];
        }
        [self hiddenMJRefresh:self.tableView];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [self hiddenMJRefresh:self.tableView];
    }];
}

- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing] ? [tableView.mj_footer endRefreshing] : nil;
    [tableView.mj_header isRefreshing] ? [tableView.mj_header endRefreshing] : nil;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = BackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.dataSource removeAllObjects];
            [self requestData:[NSString stringWithFormat:user_comment_list, self.user.id] Method:GET];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestData:self.model.result.next_page_url Method:GET];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count ?: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    TopicDataModel *model = self.dataSource.count > 0 ? [self.dataSource objectAtIndex:indexPath.row] : nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model) cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailViewController *detail = [[TopicDetailViewController alloc] init];
    TopicDataModel *data = [self.dataSource objectAtIndex:indexPath.row];
    detail.topic_id = data.topic_id;
    [self.navigationController pushViewController:detail animated:YES];
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
