//
//  TopicDetailViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicBaseCellTableViewCell.h"
#import "XjfRequest.h"
#import "TopicDetailModel.h"

@interface TopicDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicDetailModel *model;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self requestData:[topic_all stringByAppendingString:self.topic_id] method:GET];
}

- (void)requestData:(APIName *)api method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        _model = [[TopicDetailModel alloc] initWithData:responseData error:nil];
        NSLog(@"%@",_model);
        if ([_model.errCode isEqualToString:@"0"]) {
            [self.tableView reloadData];
        }
    } failedBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initMainUI {
    self.nav_title = @"话题详情";
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT-kTabBarH) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.result.replies.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicBaseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicBaseCellTableViewCell" forIndexPath:indexPath];
    cell.detail = _model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [StringUtil calculateLabelHeight:_model.result.content width:SCREENWITH-20 fontsize:15];
    if (_model.result.categories.count>0) {
        return height+140;
    }else {
        return height+116;
    }
    return height+116;
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
