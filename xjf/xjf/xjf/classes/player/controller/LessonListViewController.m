//
//  LessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonListViewController.h"
#import "VideoListCell.h"
#import "LessonPlayerViewController.h"
#import "LessonDetailViewController.h"

@interface LessonListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end

@implementation LessonListViewController
static NSString *lessonListCell_id = @"lessonListCell_id";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = self.LessonListTitle;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   [self initTabelView];
    NSString *api = [NSString stringWithFormat:@"%@%@",coursesProject,self.ID];
    [self requesData:api method:GET];
}


#pragma mark requestData
- (void)requesData:(APIName *)api method:(RequestMethod)method
{
    
    __weak typeof (self) wSelf = self;
    self.dataSource = [NSMutableArray array];
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        
        __strong typeof (self)sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
//        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//        for (NSDictionary *dic in result[@"result"][@"data"]) {
//            TalkGridModel *model = [[TalkGridModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [sSelf.dataSource addObject:model];
//            [self.tableView reloadData];
//        }
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
    }];
}
#pragma mark- initTabelView
- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    }else{
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:lessonListCell_id];
}

#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tablkListModel.result.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:lessonListCell_id];
    cell.model = self.tablkListModel.result.data[indexPath.row];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    return cell;
}
#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LessonPlayerViewController *player = [[LessonPlayerViewController alloc] init];
//    TalkGridModel *model = self.dataSource[indexPath.row];
//    player.talkGridModel = model;
//    [self.navigationController pushViewController:player animated:YES];
    LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
    lessonDetailViewController.model = self.tablkListModel.result.data[indexPath.row];
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
    
}




@end
