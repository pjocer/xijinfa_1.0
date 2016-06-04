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
#import "IndexSectionView.h"
#import "LessonPlayerViewController.h"
@interface LessonDetailLessonListViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation LessonDetailLessonListViewController
static NSString *LessonDetailLessonListCell_id = @"LessonDetailLessonListCell_id";
static CGFloat offset = 60;
static CGFloat rowHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self initTabelView];
}
#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-offset);
    }];

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = rowHeight;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[LessonDetailLessonListCell class]
           forCellReuseIdentifier:LessonDetailLessonListCell_id];

    //tableHeaderView
    if (_isPay) {
        self.tableView.tableHeaderView = [[LessonDetailHaveToPayHeaderView alloc]
                initWithFrame:CGRectMake(0, 0, SCREENWITH, 36)];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
//    else {
//        self.tableView.tableHeaderView = [[LessonDetailNoPayHeaderView alloc]
//                initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight)];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    }

}

#pragma mark TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lessonDetailListModel.result.lessons.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LessonDetailListLessonsModel *model = self.lessonDetailListModel.result.lessons[section];
    if ([model.type isEqualToString:@"dir"]) {
        return model.children.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LessonDetailLessonListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonDetailLessonListCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backgroundColor = [UIColor clearColor];
    if (!_isPay) {
        cell.studyImage.hidden = YES;
    }
    LessonDetailListLessonsModel *model = self.lessonDetailListModel.result.lessons[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        TalkGridModel *tempModel = model.children[indexPath.row];
        cell.talkGridModel = tempModel;
        
        //是否免费试看
        if ([cell.talkGridModel.package containsObject:@"visitor"]) {
            cell.freeVideoLogo.hidden = NO;
        }else {
            cell.freeVideoLogo.hidden = YES;
        }
        //是否收藏
        if (cell.talkGridModel.user_favored) {
            cell.favorites.image = [UIImage imageNamed:@"iconFavoritesOn"];
        }
    } else if ([model.type isEqualToString:@"lesson"]) {
        cell.lessonDetailListModel = model;
        //是否免费试看
        if ([cell.lessonDetailListModel.package containsObject:@"visitor"]) {
            cell.freeVideoLogo.hidden = NO;
        }else {
            cell.freeVideoLogo.hidden = YES;
        }
        //是否收藏
        if (cell.lessonDetailListModel.user_favored) {
            cell.favorites.image = [UIImage imageNamed:@"iconFavoritesOn"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    LessonDetailListLessonsModel *model = self.lessonDetailListModel.result.lessons[section];
    if ([model.type isEqualToString:@"dir"]) {
        return 35;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LessonDetailListLessonsModel *model = self.lessonDetailListModel.result.lessons[section];
    if ([model.type isEqualToString:@"dir"]) {
        IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
        [sectionView addSubview:bottomView];
        bottomView.backgroundColor = BackgroundColor;
        sectionView.moreLabel.hidden = YES;
        [sectionView.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        sectionView.titleLabel.text = model.title;
        return sectionView;
    }
    return nil;
}


#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LessonDetailListLessonsModel *model = self.lessonDetailListModel.result.lessons[indexPath.section];
   
    if ([model.type isEqualToString:@"dir"]) {
        TalkGridModel *tempModel = model.children[indexPath.row];
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lessonDetailListModel = self.lessonDetailListModel;
        lessonPlayerViewController.lesssonID = self.lessonDetailListModel.result.id;
        
        if (tempModel.video_player.count != 0) {
            TalkGridVideo *gridVideomodel = tempModel.video_player.firstObject;
            lessonPlayerViewController.playUrl =  gridVideomodel.url;
        }
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    } else if ([model.type isEqualToString:@"lesson"]) {
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lessonDetailListModel = self.lessonDetailListModel;
        lessonPlayerViewController.lesssonID = self.lessonDetailListModel.result.id;
        
        if (model.video_player.count != 0) {
        TalkGridVideo *gridVideomodel = model.video_player.firstObject;
        lessonPlayerViewController.playUrl =  gridVideomodel.url;
        }
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    }
}

@end
