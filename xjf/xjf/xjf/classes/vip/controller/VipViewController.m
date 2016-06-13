//
//  VipViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VipViewController.h"
#import "TalkGridModel.h"
#import "VideoListCell.h"
#import "IndexSectionView.h"
#import "VipHeaderView.h"
#import "LessonDetailViewController.h"
#import "XJAccountManager.h"
#import "LoginViewController.h"
#import "VipPayListViewController.h"
@interface VipViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VipHeaderView *tableHeaderView;
@end

@implementation VipViewController
static NSString *VipTableCell_id = @"VipTableCell_id";
static CGFloat tableSectionHeaderH = 35;
static CGFloat tableHeaderH = 200;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"会员";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    [self requestLessonListApi:coursesProjectLessonDetailList method:GET];
}

- (void)requestLessonListApi:(APIName *)lessonListApi
                      method:(RequestMethod)method
{
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:lessonListApi RequestMethod:method];
    
    //tablkListModel_Lesson
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
    }failedBlock:^(NSError *_Nullable error) {
    }];
    
}

#pragma mark - initTabelView
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
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:VipTableCell_id];
    //tableHeaderView
    self.tableHeaderView = [[VipHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, tableHeaderH)];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableHeaderView.login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeaderView.payVip addTarget:self action:@selector(tableHeaderViewPayAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark TabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tablkListModel.result.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VipTableCell_id];
    cell.model = self.tablkListModel.result.data[indexPath.row];
    cell.lessonCount.hidden = NO;
    cell.teacherName.hidden = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableSectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    [sectionView addSubview:bottomView];
    bottomView.backgroundColor = BackgroundColor;
    sectionView.titleLabel.text = @"推荐课程";
    sectionView.moreLabel.hidden = YES;
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexHandleSingleTapFrom:)];
    [sectionView addGestureRecognizer:singleRecognizer];
    return sectionView;
}
- (void)indexHandleSingleTapFrom:(UITapGestureRecognizer *)sender
{
    NSLog(@"更多");
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //析金学堂
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
    lessonDetailViewController.model = self.tablkListModel.result.data[indexPath.row];
    lessonDetailViewController.apiType = coursesProjectLessonDetailList;
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}

#pragma mark - login
- (void)login:(UIButton *)sender
{
    //用户未登录
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
        [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        
    }
}

#pragma mark - tableHeaderViewPayAction
- (void)tableHeaderViewPayAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"开通会员"]) {
        VipPayListViewController *vipPayListViewController = [VipPayListViewController new];
        [self.navigationController pushViewController:vipPayListViewController animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"续费会员"]){
        
    }
}


@end
