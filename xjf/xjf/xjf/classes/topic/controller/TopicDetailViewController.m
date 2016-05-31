//
//  TopicDetailViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "XjfRequest.h"
#import "TopicDetailModel.h"
#import "TopicCommentList.h"
#import "CommentDetailHeader.h"
#import "ZToastManager.h"

@interface TopicDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicDetailModel *model;
@property (nonatomic, strong) TopicCommentList *commentList;
@property (nonatomic, strong) CommentDetailHeader *header;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self initData];
}

- (void)initData {
    [self requestData:[topic_all stringByAppendingString:self.topic_id] method:GET];
    [self requestData:[NSString stringWithFormat:@"%@%@/reply",topic_all,self.topic_id] method:GET];
}

- (void)requestData:(APIName *)api method:(RequestMethod)method {
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        if ([api isEqualToString:[topic_all stringByAppendingString:self.topic_id]]) {
            _model = [[TopicDetailModel alloc] initWithData:responseData error:nil];
            if ([_model.errCode isEqualToString:@"0"]) {
                [self.tableView reloadData];
            }else {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
            }
        }else if ([api isEqualToString:[NSString stringWithFormat:@"%@%@/reply",topic_all,self.topic_id]]) {
            _commentList = [[TopicCommentList alloc] initWithData:responseData error:nil];
            if ([_model.errCode isEqualToString:@"0"]) {
                NSLog(@"%@",_commentList);
                [self.tableView reloadData];
            }else {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
            }
        }
        [[ZToastManager ShardInstance] hideprogress];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络请求失败"];
    }];
}

- (void)initMainUI {
    self.nav_title = @"话题详情";
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT-kTabBarH) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"CommentDetailHeader" bundle:nil] forCellReuseIdentifier:@"CommentDetailHeader"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+_commentList.result.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _header = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailHeader" forIndexPath:indexPath];
        _header.model = _model;
        _header.selectionStyle = UITableViewCellSelectionStyleNone;
        return _header;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return _header.cellHeight;
    }
    return 50;
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
