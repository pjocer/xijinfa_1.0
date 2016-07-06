//
//  LessonPlayerLessonCommentsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonCommentsViewController.h"
#import "VideoListCell.h"
#import <MJRefresh.h>
#import "PlayerViewController.h"

@interface LessonPlayerLessonCommentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end

@implementation LessonPlayerLessonCommentsViewController
static NSString *LessonCommentsCel_id = @"LessonCommentsCel_id";


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
    [self initTabelView];
    [self requesData:talkGrid method:GET];
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

    }                  failedBlock:^(NSError *_Nullable error) {
        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        [sSelf.tableView.mj_footer isRefreshing] ? [sSelf.tableView.mj_footer endRefreshing] : nil;
    }];
}

- (void)loadMoreData {
    if (self.tablkListModel.result.next_page_url != nil) {
        [self requesData:self.tablkListModel.result.next_page_url method:GET];
    } else if (self.tablkListModel.result.current_page == self.tablkListModel.result.last_page) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [[ZToastManager ShardInstance] showtoast:@"没有更多数据"];
        [self.tableView.mj_footer removeFromSuperview];
    }
}


#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);

    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    if (iPhone5) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:LessonCommentsCel_id];
    if (!self.tableView.mj_footer) {
        //mj_footer
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter
                footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.mj_footer.automaticallyHidden = YES;
    }
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonCommentsCel_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayerViewController *player = [[PlayerViewController alloc] init];
    TalkGridModel *model = self.dataSource[indexPath.row];
    player.talkGridModel = model;
    player.talkGridListModel = self.tablkListModel;
    [self.navigationController pushViewController:player animated:YES];

}


@end
