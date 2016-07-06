//
//  TopicViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicConfigure.h"
#import <MJRefresh/MJRefresh.h>
#import "XjfRequest.h"
#import "TopicModel.h"
#import "TopicBaseCellTableViewCell.h"
#import "ZToastManager.h"
#import "TopicDetailViewController.h"
#import "XJAccountManager.h"
#import "UITableViewCell+AvatarEnabled.h"

@interface TopicViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *all;
@property (nonatomic, strong) TopicModel *model_all;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, strong) UITableView *tableView_all;
@end

@implementation TopicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self extendheadViewFor:Topic];
    [self initMainUI];
    [_tableView_all.mj_header beginRefreshing];
}

- (void)initData {
    [self reqeustData:topic_all method:GET tableView:_tableView_all];
}

- (void)reqeustData:(APIName *)api method:(RequestMethod)method tableView:(UITableView *)tableView {
    if (api == nil) {
        [self hiddenMJRefresh:tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        TopicModel *model = [[TopicModel alloc] initWithData:responseData error:nil];
        _model_all = model;
        [_allDataSource addObjectsFromArray:_model_all.result.data];
        [_tableView_all reloadData];
        [self hiddenMJRefresh:tableView];
    }                  failedBlock:^(NSError *_Nullable error) {
        [self hiddenMJRefresh:tableView];
        [[ZToastManager ShardInstance] showtoast:@"请求数据失败"];
    }];
}

- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing] ? [tableView.mj_footer endRefreshing] : nil;
    [tableView.mj_header isRefreshing] ? [tableView.mj_header endRefreshing] : nil;
}

- (void)initMainUI {
    self.view.backgroundColor = BackgroundColor;
    [self.view addSubview:self.tableView_all];
    self.navigationItem.title = @"讨论";
}

- (UITableView *)tableView_all {
    if (!_tableView_all) {
        _allDataSource = [NSMutableArray array];
        _tableView_all = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT) style:UITableViewStylePlain];
        [_tableView_all registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView_all.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_allDataSource.count > 0) {
                [_allDataSource removeAllObjects];
            }
            [self reqeustData:topic_all method:GET tableView:_tableView_all];
        }];
        _tableView_all.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self reqeustData:_model_all.result.next_page_url method:GET tableView:_tableView_all];
        }];
        _tableView_all.estimatedRowHeight = 1000;
        _tableView_all.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView_all.delegate = self;
        _tableView_all.dataSource = self;
        _tableView_all.backgroundColor = BackgroundColor;
    }
    return _tableView_all;
}

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView_all) {
        return _allDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicBaseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicBaseCellTableViewCell" forIndexPath:indexPath];
    TopicDataModel *model = nil;
    if (tableView == _tableView_all) {
        if (_allDataSource.count > 0 && _allDataSource != nil) {
            model = [_allDataSource objectAtIndex:indexPath.row];
        }
    }
    cell.avatarEnabled = ![model.user.id isEqualToString:[[XJAccountManager defaultManager] user_id]];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDataModel *model = nil;
    if (tableView == _tableView_all) {
        if (_allDataSource.count > 0 && _allDataSource != nil) {
            model = [_allDataSource objectAtIndex:indexPath.row];
        }
    }
    TopicDetailViewController *controller = [[TopicDetailViewController alloc] init];
    controller.topic_id = model.id;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
