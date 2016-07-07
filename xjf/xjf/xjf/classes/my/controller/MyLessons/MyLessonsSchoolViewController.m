//
//  MyLessonsSchoolViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyLessonsSchoolViewController.h"
#import "VideoListCell.h"
#import "MyLessonsTableFooterView.h"
#import "TalkGridModel.h"
#import "LessonPlayerViewController.h"

@interface MyLessonsSchoolViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation MyLessonsSchoolViewController
static NSString *MyLessonsSchool_id = @"MyLessonsSchool_id";
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

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyLessonsSchool_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSorce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyLessonsSchool_id];
    cell.model = self.dataSorce[indexPath.section];
    cell.viedoDetail.hidden = YES;
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = YES;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MyLessonsTableFooterView *myLessonsTableFooterView = [[MyLessonsTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, tableFooterH)];
    return myLessonsTableFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return tableFooterH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
    lessonPlayerViewController.playTalkGridModel = self.dataSorce[indexPath.section];
    lessonPlayerViewController.lesssonID = lessonPlayerViewController.playTalkGridModel.id_;
    lessonPlayerViewController.originalTalkGridModel = self.dataSorce[indexPath.section];
    [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
}

@end
