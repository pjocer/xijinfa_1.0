//
//  TaTopicViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TaTopicViewController.h"
#import "TopicBaseCellTableViewCell.h"
#import "TopicModel.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import <MJRefresh/MJRefresh.h>
#import "TopicDetailViewController.h"
#import "UITableViewCell+AvatarEnabled.h"

@interface TaTopicViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;
@end

#define USER_TOPIC_API [NSString stringWithFormat:@"/api/user/%@/topic",self.user_id]

@implementation TaTopicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

- (instancetype)initWithID:(NSString *)userId nickname:(NSString *)nickname {
    self = [super init];
    if (self) {
        _user_id = userId;
        _nickname = nickname;
    }
    return self;
}

- (void)initMainUI {
    self.navigationItem.title = [NSString stringWithFormat:@"%@的讨论", self.nickname];
    self.dataSource = [NSMutableArray array];
    [self requestData:USER_TOPIC_API Method:GET];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackgroundColor;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _model = nil;
            [_dataSource removeAllObjects];
            [self requestData:USER_TOPIC_API Method:GET];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestData:self.model.result.next_page_url Method:GET];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)requestData:(APIName *)api Method:(RequestMethod)method {
    if (api == nil) {
        [self hiddenMJRefresh:self.tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        _model = [[TopicModel alloc] initWithData:responseData error:nil];
        if (_model.errCode == 0) {
            [self.dataSource addObjectsFromArray:_model.result.data];
            [self.tableView reloadData];
        } else {
            [[ZToastManager ShardInstance] showtoast:_model.errMsg];
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

#pragma mark - TableView Deleagte

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        TopicDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
        TopicDetailViewController *controller = [[TopicDetailViewController alloc] init];
        controller.topic_id = model.id;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicBaseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicBaseCellTableViewCell" forIndexPath:indexPath];
    if (self.dataSource.count > 0) {
        TopicDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.model = model;
    }
    cell.avatarEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDataModel *model = self.dataSource&&self.dataSource.count>0?self.dataSource[indexPath.row]:nil;
    CGFloat height = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-40 fontsize:15]+81+42;
    height = height>210?202:height;
    return height;
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
