//
//  LessonDetailTecherDescribeViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailTecherDescribeViewController.h"
#import "LessonDetailTecherDescribeCell.h"
@interface LessonDetailTecherDescribeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LessonDetailTecherDescribeViewController
static NSString *LessonDetailTecherDescribeCell_id = @"LessonDetailTecherDescribeCell_id";
static CGFloat offset = 60;
static CGFloat rowHeight = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
}

#pragma mark- initTabelView
- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(- offset);
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = rowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[LessonDetailTecherDescribeCell class] forCellReuseIdentifier:LessonDetailTecherDescribeCell_id];
}

#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LessonDetailTecherDescribeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonDetailTecherDescribeCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击LessonDetailTecherDescribeCell : %ld",indexPath.row);
}

@end
