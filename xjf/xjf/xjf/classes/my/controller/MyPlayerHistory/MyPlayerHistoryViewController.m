//
//  MyPlayerHistoryViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyPlayerHistoryViewController.h"
#import "TalkGridModel.h"
#import "VideoListCell.h"
#import "IndexSectionView.h"
#import "LessonDetailViewController.h"
@interface MyPlayerHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation MyPlayerHistoryViewController
static NSString *MyPlayerHistoryCell_id = @"MyPlayerHistoryCell_id";
static CGFloat tableHeaderH = 35;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"播放记录";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    
}

#pragma mark requestData
- (void)requesData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];

    }failedBlock:^(NSError *_Nullable error) {

    }];
}

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
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyPlayerHistoryCell_id];
}
#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyPlayerHistoryCell_id];
//    cell.model = self.dataSource[indexPath.row];
    cell.oldPrice.hidden = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    [sectionView addSubview:bottomView];
    bottomView.backgroundColor = BackgroundColor;
    sectionView.moreLabel.hidden = YES;
//    sectionView.titleLabel.text = model.title;
    sectionView.titleLabel.text = @"xxxx";
    return sectionView;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
//    lessonDetailViewController.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}


@end
