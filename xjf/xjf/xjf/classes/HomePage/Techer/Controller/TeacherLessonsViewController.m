//
//  TeacherLessonsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherLessonsViewController.h"
#import "VideoListCell.h"
#import "LessonDetailViewController.h"

@interface TeacherLessonsViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation TeacherLessonsViewController
static NSString *TeacherLessonsCell_id = @"TeacherLessonsCell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
            initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:TeacherLessonsCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TeacherLessonsCell_id];
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
