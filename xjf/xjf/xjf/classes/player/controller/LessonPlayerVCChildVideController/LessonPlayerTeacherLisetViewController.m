//
//  LessonPlayerTeacherLisetViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerTeacherLisetViewController.h"
#import "FansCell.h"
#import "TeacherDetalPage.h"

@interface LessonPlayerTeacherLisetViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation LessonPlayerTeacherLisetViewController
static NSString *LessonCommentsCel_id = @"LessonPlayerTeacherLisetViewControllerCell_ID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
}

- (void)setLessonDetailListModel:(LessonDetailListModel *)lessonDetailListModel
{
    if (lessonDetailListModel) {
        _lessonDetailListModel = lessonDetailListModel;
    }
    [self.tableView reloadData];
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = 82;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"FansCell" bundle:nil] forCellReuseIdentifier:LessonCommentsCel_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lessonDetailListModel.result.taxonomy_gurus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:LessonCommentsCel_id forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.teacherModel = _lessonDetailListModel.result.taxonomy_gurus[indexPath.row];
    return cell;

}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeacherDetalPage *teacherDetailViewController = [[TeacherDetalPage alloc] init];
    teacherDetailViewController.teacherListDataModel = _lessonDetailListModel.result.taxonomy_gurus[indexPath.row];
    [self.navigationController pushViewController:teacherDetailViewController animated:YES];
}

- (void)dealloc
{

}

@end
