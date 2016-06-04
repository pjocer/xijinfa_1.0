//
//  MyLessonsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyLessonsViewController.h"
#import "VideoListCell.h"
#import "MyLessonsTableFooterView.h"
#import "TalkGridModel.h"
#import "LessonDetailViewController.h"
@interface MyLessonsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end

@implementation MyLessonsViewController
static NSString *MyLessonsCell_id = @"MyLessonsCell_id";
static CGFloat tableFooterH = 35;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"我的课程";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    [self requesData:myLessonsApi method:GET];
}
#pragma mark requestData

- (void)requesData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
        [[ZToastManager ShardInstance] hideprogress];
        
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyLessonsCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tablkListModel.result.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyLessonsCell_id];
    cell.model = self.tablkListModel.result.data[indexPath.section];
    cell.viedoDetail.hidden = NO;
    cell.price.hidden = YES;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyLessonsTableFooterView *myLessonsTableFooterView = [[MyLessonsTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, tableFooterH)];
    return myLessonsTableFooterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableFooterH;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
    lessonDetailViewController.model = self.tablkListModel.result.data[indexPath.section];
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}


@end
