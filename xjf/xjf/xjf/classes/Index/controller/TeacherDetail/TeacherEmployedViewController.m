//
//  TeacherEmployedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherEmployedViewController.h"
#import "VideoListCell.h"
#import "LessonDetailViewController.h"
@interface TeacherEmployedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TeacherEmployedViewController
static NSString *TeacherEmployedCell_id = @"TeacherLessonsCell_id";
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
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:TeacherEmployedCell_id];
}
#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TeacherEmployedCell_id];
    cell.model = self.dataSource[indexPath.row];
    NSLog(@"---- %@",cell.model.price);
    NSLog(@"----------- %@",cell.model.thumbnail);
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
