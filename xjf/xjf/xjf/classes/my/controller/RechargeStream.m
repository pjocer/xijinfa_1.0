//
//  RechargeResult.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RechargeStream.h"
#import "RechargeStreamCell.h"
#import "RechargeStreamModel.h"
#import <MJRefresh/MJRefresh.h>
#import "ZToastManager.h"
@interface RechargeStream () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RechargeStreamModel *model;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation RechargeStream
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额流水";
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self requestData:recharge_stream Method:GET];
}
- (void)requestData:(APIName *)api Method:(RequestMethod)method{
    if (api == nil) {
        [self hiddenMJRefresh:_tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        self.model = [[RechargeStreamModel alloc] initWithData:responseData error:nil];
        if (self.model.errCode == 0) {
            [self.dataSource addObjectsFromArray:self.model.result.data];
            [self.tableView reloadData];
        }else {
            [[ZToastManager ShardInstance] showtoast:self.model.errMsg];
        }
        [self hiddenMJRefresh:_tableView];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [self hiddenMJRefresh:_tableView];
    }];
}
- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing] ? [tableView.mj_footer endRefreshing] : nil;
    [tableView.mj_header isRefreshing] ? [tableView.mj_header endRefreshing] : nil;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"RechargeStreamCell" bundle:nil] forCellReuseIdentifier:@"RechargeStreamCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.dataSource removeAllObjects];
            [self requestData:recharge_stream Method:GET];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestData:self.model.result.next_page_url Method:GET];
        }];
        _tableView.estimatedRowHeight = 1000;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeStreamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeStreamCell" forIndexPath:indexPath];
    cell.model = self.dataSource&&self.dataSource.count>0?[self.dataSource objectAtIndex:indexPath.row]:nil;
    return cell;
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
