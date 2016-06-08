//
//  MyTopicViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/3.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyTopicViewController.h"
#import "TopicBaseCellTableViewCell.h"
#import "TopicModel.h"
#import "XJAccountManager.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import <MJRefresh/MJRefresh.h>
#import "TopicDetailViewController.h"
@interface MyTopicViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyTopicViewController

#define USER_ID [[[[XJAccountManager defaultManager] user_model] result] id]
#define USER_TOPIC_API [NSString stringWithFormat:@"/api/user/%@/topic",USER_ID]

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)initMainUI {
    self.nav_title = @"我的话题";
    self.dataSource = [NSMutableArray array];
    [self requestData:USER_TOPIC_API Method:GET];
    [self.view addSubview:self.tableView];
}
- (void)requestData:(APIName *)api Method:(RequestMethod)method {
    if (api == nil) {
        [self hiddenMJRefresh:self.tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        _model = [[TopicModel alloc] initWithData:responseData error:nil];
        if (_model.errCode == 0) {
            [self.dataSource addObjectsFromArray:_model.result.data];
            [self.tableView reloadData];
        }else {
            [[ZToastManager ShardInstance] showtoast:_model.errMsg];
        }
        [self hiddenMJRefresh:self.tableView];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [self hiddenMJRefresh:self.tableView];
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (CGFloat)cellHeightByModel:(TopicDataModel *)model {
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-20 fontsize:15];
    CGFloat height = 10+40+10+contentHeight + 10;
    CGFloat all = 0;
    CGFloat alll = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat tap = 10;
    NSMutableArray *labels = [NSMutableArray array];
    for (CategoryLabel *label in model.categories) {
        [labels addObject:label.name];
    }
    for (int i = 0; i < labels.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"#%@#",labels[i]];
        CGSize size = [title sizeWithFont:FONT12 constrainedToSize:CGSizeMake(SCREENWITH, 14) lineBreakMode:1];
        all = all + tap + size.width;
        if (all <= SCREENWITH) {
            x = all - size.width;
            y = contentHeight+70;
            button.frame = CGRectMake(x, y, size.width, 14);
            return height + 34 + 36;
        }else if (all <= SCREENWITH*2 && all>SCREENWITH) {
            alll = alll + tap + size.width;
            if (alll <= SCREENWITH) {
                x = alll - size.width;
                y = contentHeight+94;
                button.frame = CGRectMake(x, y, size.width, 14);
                return height + 30 + 28 + 36;
            }else {
                return height + 36+10;
            }
        }
    }
    return height+36+10;
}
- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing]?[tableView.mj_footer endRefreshing]:nil;
    [tableView.mj_header isRefreshing]?[tableView.mj_header endRefreshing]:nil;
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
    if (self.dataSource.count>0) {
        TopicDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count>0) {
        TopicDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
        return [self cellHeightByModel:model];
    }
    return 0;
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
