//
//  Fans_FocusViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "Fans_FocusViewController.h"
#import "FansFocus.h"
#import <MJRefresh/MJRefresh.h>
#import "FansCell.h"
#import <UIImageView+WebCache.h>
#import "TaViewController.h"
@interface Fans_FocusViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) FansFocus *model;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger type;//0 粉丝 1 关注
@property (nonatomic, copy) NSString *nickname;
@end

@implementation Fans_FocusViewController
#define FANSFOCUS_API [NSString stringWithFormat:@"/api/friendship/%@/%@",self.user_id,self.type==0?@"followers":@"followings"]
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
-(instancetype)initWithID:(NSString *)userId type:(NSInteger)type nickname:(NSString *)nickname {
    self = [super init];
    if (self) {
        _user_id = userId;
        _type = type;
        _nickname = nickname;
    }
    return self;
}
- (void)initMainUI {
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self initNavBar];
    [self requestData:FANSFOCUS_API Method:GET];
}
- (void)initNavBar {
    self.nav_title = [NSString stringWithFormat:@"%@%@",self.nickname,self.type==0?@"的粉丝":@"关注的人"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_ta"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)settingAction:(UIBarButtonItem *)item {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"回到首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"FansCell" bundle:nil] forCellReuseIdentifier:@"FansCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _model = nil;
            [_dataSource removeAllObjects];
            [self requestData:FANSFOCUS_API Method:GET];
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
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        _model = [[FansFocus alloc] initWithData:responseData error:nil];
        if ([_model.errCode isEqualToString:@"0"]) {
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
- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing]?[tableView.mj_footer endRefreshing]:nil;
    [tableView.mj_header isRefreshing]?[tableView.mj_header endRefreshing]:nil;
}
#pragma mark - TableView Deleagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource != nil && self.dataSource.count>0) {
        TaViewController *ta = [[TaViewController alloc] init];
        UserInfoModel *model = [self.dataSource objectAtIndex:indexPath.row];
        ta.model = model;
        [self.navigationController pushViewController:ta animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource != nil && self.dataSource.count>0) {
        UserInfoModel *model = [self.dataSource objectAtIndex:indexPath.row];
        FansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        cell.nickname.text = model.nickname;
        cell.summary.text = @"等待API";
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
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
