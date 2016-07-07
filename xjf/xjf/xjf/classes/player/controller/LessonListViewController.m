//
//  LessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonListViewController.h"
#import "VideoListCell.h"
#import "LessonDetailViewController.h"
#import <MJRefresh.h>

@interface LessonListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LessonListViewController
static NSString *lessonListCell_id = @"lessonListCell_id";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    self.navigationItem.title = self.LessonListTitle;
    if (self.ID) {
        NSString *api = [NSString stringWithFormat:@"%@%@", coursesProject, self.ID];
        [self requesData:api method:GET];
    } else {
        [self requesData:coursesProjectLessonDetailList method:GET];
    }
}

- (void)loadMoreData {
    if (self.tablkListModel.result.next_page_url != nil) {
        [self requesData:self.tablkListModel.result.next_page_url method:GET];
    } else if (self.tablkListModel.result.current_page == self.tablkListModel.result.last_page) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark requestData

- (void)requesData:(APIName *)api method:(RequestMethod)method {

    __weak typeof(self) wSelf = self;
    [[ZToastManager ShardInstance] showprogress];

    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.dataSource addObjectsFromArray:sSelf.tablkListModel.result.data];
        [sSelf.tableView.mj_footer isRefreshing] ? [sSelf.tableView.mj_footer endRefreshing] : nil;
        [sSelf.tableView reloadData];
        [[ZToastManager ShardInstance] hideprogress];
        if (!self.tableView.mj_footer) {
            //mj_footer
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                            refreshingAction:@selector(loadMoreData)];
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [sSelf.tableView.mj_footer isRefreshing] ? [sSelf.tableView.mj_footer endRefreshing] : nil;
    }];
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
            initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:lessonListCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:lessonListCell_id];
    cell.model = self.dataSource[indexPath.row];
    cell.oldPrice.hidden = NO;
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
    lessonDetailViewController.model = self.dataSource[indexPath.row];
    if ([lessonDetailViewController.model.department isEqualToString:@"dept3"]) {
        lessonDetailViewController.apiType = coursesProjectLessonDetailList;
    } else if ([lessonDetailViewController.model.department isEqualToString:@"dept4"]) {
        lessonDetailViewController.apiType = EmployedLessonDetailList;
    }
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}

@end
