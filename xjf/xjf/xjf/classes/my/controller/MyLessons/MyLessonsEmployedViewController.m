//
//  MyLessonsEmployedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyLessonsEmployedViewController.h"
#import "VideoListCell.h"
#import "MyLessonsTableFooterView.h"
#import "TalkGridModel.h"
#import "LessonDetailViewController.h"
@interface MyLessonsEmployedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyLessonsEmployedViewController
static NSString *MyLessonsEmployed_id = @"MyLessonsEmployed_id";
static CGFloat tableFooterH = 35;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
}

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 100) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyLessonsEmployed_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSorce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyLessonsEmployed_id];
    cell.model = self.dataSorce[indexPath.section];
    cell.viedoDetail.hidden = YES;
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
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
    lessonDetailViewController.model = self.dataSorce[indexPath.section];
     lessonDetailViewController.apiType = EmployedLessonDetailList;
    [self.navigationController pushViewController:lessonDetailViewController animated:YES];
}


@end
