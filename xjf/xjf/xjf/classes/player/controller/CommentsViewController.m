//
//  CommentsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentsViewController.h"
#import "playerConfigure.h"
#import <MJRefresh.h>

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
///评论数据
@property (nonatomic, strong) CommentsAllDataList *commentsModel;
@end

@implementation CommentsViewController
static NSString *CommentsCell_id = @"CommentsCell_id";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部评论";
    [self initTabelView];
    [self requestCommentsData:[NSString stringWithFormat:@"%@%@/comments", talkGridcomments, self.ID] method:GET];
}


#pragma mark requestData

- (void)requestCommentsData:(APIName *)api method:(RequestMethod)method {

    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.commentsModel = [[CommentsAllDataList alloc] initWithData:responseData error:nil];
        [self.dataSource addObjectsFromArray:self.commentsModel.result.data];
        [self.tableView.mj_footer isRefreshing] ? [self.tableView.mj_footer endRefreshing] : nil;
        [self.tableView reloadData];
    } failedBlock:^(NSError *_Nullable error) {
        [self.tableView.mj_footer isRefreshing] ? [self.tableView.mj_footer endRefreshing] : nil;
    }];

}

- (void)loadMoreData {
    if (self.commentsModel.result.next_page_url != nil) {
        [self requestCommentsData:self.commentsModel.result.next_page_url method:GET];
    } else if (self.commentsModel.result.current_page == self.commentsModel.result.last_page) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [[ZToastManager ShardInstance] showtoast:@"没有更多数据"];
        [self.tableView.mj_footer removeFromSuperview];
    }
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 30)
                                                  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[CommentsPageCommentsCell class] forCellReuseIdentifier:CommentsCell_id];
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    }
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsPageCommentsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CommentsCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentsModel = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsModel *model = self.dataSource[indexPath.section];
    CGRect tempRect = [StringUtil calculateLabelRect:model.content width:SCREENWITH - 70 fontsize:15];
    return tempRect.size.height + 60;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
