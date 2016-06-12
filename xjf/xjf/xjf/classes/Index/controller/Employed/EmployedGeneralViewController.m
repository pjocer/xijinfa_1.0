//
//  EmployedGeneralViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedGeneralViewController.h"
#import "VideoListCell.h"
#import "TalkGridModel.h"
#import "LessonDetailViewController.h"
#import <MJRefresh.h>
@interface EmployedGeneralViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation EmployedGeneralViewController
static NSString *EmployedGeneralCell_id = @"EmployedGeneralCell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    self.dataSource = [NSMutableArray array];
    [self requesData:[NSString stringWithFormat:@"%@%@",employedCategory,self.ID] method:GET];
}


#pragma mark requestData
- (void)requesData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.dataSource addObjectsFromArray:sSelf.tablkListModel.result.data];
        [sSelf.tableView.mj_footer isRefreshing]?[sSelf.tableView.mj_footer endRefreshing]:nil;
        [sSelf.tableView reloadData];
    }failedBlock:^(NSError *_Nullable error) {
        __strong typeof(self) sSelf = wSelf;
        [sSelf.tableView.mj_footer isRefreshing]?[sSelf.tableView.mj_footer endRefreshing]:nil;
    }];
}

- (void)loadMoreData
{
    if (self.tablkListModel.result.next_page_url != nil) {
        [self requesData:self.tablkListModel.result.next_page_url method:GET];
    } else if (self.tablkListModel.result.current_page == self.tablkListModel.result.last_page)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 100) style:UITableViewStylePlain];
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
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:EmployedGeneralCell_id];
    
    if (!self.tableView.mj_footer) {
        //mj_footer
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}

#pragma mark TabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EmployedGeneralCell_id];
    cell.model = self.dataSource[indexPath.row];
    cell.viedoDetail.hidden = YES;
    return cell;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
    lessonDetailViewController.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}


@end
