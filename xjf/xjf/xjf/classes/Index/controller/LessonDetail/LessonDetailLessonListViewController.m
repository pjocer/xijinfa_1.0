//
//  LessonDetailLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailLessonListViewController.h"
#import "LessonDetailLessonListCell.h"
#import "LessonDetailNoPayHeaderView.h"
#import "LessonDetailHaveToPayHeaderView.h"

@interface LessonDetailLessonListViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LessonDetailLessonListViewController
static NSString *LessonDetailLessonListCell_id = @"LessonDetailLessonListCell_id";
static CGFloat offset = 60;
static CGFloat rowHeight = 35;

//- (void)dealloc
//{
//    if (self.ID.length != 0) {
//       self.ID = nil;
//    }
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
    [self initTabelView];

    NSString *api = [NSString stringWithFormat:@"%@%@", coursesProjectLessonDetailList, self.ID];
    [self requestLessonListData:api method:GET];
}

- (void)requestLessonListData:(APIName *)api method:(RequestMethod)method {


    __weak typeof(self) wSelf = self;
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];

        sSelf.lessonDetailListModel = [[LessonDetailListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-offset);
    }];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = rowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[LessonDetailLessonListCell class]
           forCellReuseIdentifier:LessonDetailLessonListCell_id];

    //tableHeaderView
    if (_isPay) {
        self.tableView.tableHeaderView = [[LessonDetailHaveToPayHeaderView alloc]
                initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight * 2 + 1)];
        self.tableView.backgroundColor = [UIColor whiteColor];
    } else {
        self.tableView.tableHeaderView = [[LessonDetailNoPayHeaderView alloc]
                initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight)];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }

}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lessonDetailListModel.result.lessons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LessonDetailLessonListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonDetailLessonListCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = BackgroundColor;
    }
    if (!_isPay) {
        cell.studyImage.hidden = YES;
    }
    cell.model = self.lessonDetailListModel.result.lessons[indexPath.row];
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击LessonListCell : %ld", indexPath.row);
}

@end
