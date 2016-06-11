//
//  LessonPlayerLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonListViewController.h"
#import "LessonDetailLessonListCell.h"
#import "LessonDetailNoPayHeaderView.h"
#import "LessonDetailHaveToPayHeaderView.h"
#import "IndexSectionView.h"
#import "LessonPlayerViewController.h"
@interface LessonPlayerLessonListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LessonPlayerLessonListViewController
static NSString *LessonListCell_id = @"LessonListCell_id";
static CGFloat offset = 60;
static CGFloat rowHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.isPay = self.lessonDetailListModel.result.user_purchased;
    [self initTabelView];
}



#pragma mark- initTabelView
- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = rowHeight;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[LessonDetailLessonListCell class]
           forCellReuseIdentifier:LessonListCell_id];
    
    //tableHeaderView
//    if (_isPay) {
//        self.tableView.tableHeaderView = [[LessonDetailHaveToPayHeaderView alloc]
//                                          initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight * 2 + 1)];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    } else {
//        self.tableView.tableHeaderView = [[LessonDetailNoPayHeaderView alloc]
//                                          initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight)];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    }
}
#pragma mark TabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lessonDetailListModel.result.lessons_menu.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    
    if ([model.type isEqualToString:@"dir"]) {
        return model.children.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LessonDetailLessonListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonListCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    if (!_isPay) {
        cell.studyImage.hidden = YES;
    }
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        TalkGridModel *tempModel = model.children[indexPath.row];
        cell.talkGridModel = tempModel;
        [self lessonDetailLessonListCellJudge:cell];
    } else if ([model.type isEqualToString:@"lesson"]) {
        cell.talkGridModel = model;
        [self lessonDetailLessonListCellJudge:cell];
    }

    return cell;
}

///Cell 判断性操作
- (void)lessonDetailLessonListCellJudge:(LessonDetailLessonListCell *)cell
{
    //是否免费试看
    if ([cell.talkGridModel.package containsObject:@"visitor"]) {
        cell.freeVideoLogo.hidden = NO;
    }else {
        cell.freeVideoLogo.hidden = YES;
    }
    //是否收藏
    if (cell.talkGridModel.user_favored) {
        cell.favorites.image = [UIImage imageNamed:@"iconFavoritesOn"];
    }else {
        cell.favorites.image = nil;
    }
    //是否是正在观看的课程
    if ([cell.talkGridModel.id_ isEqualToString:self.selectedModel.id_]) {
        cell.title.textColor = BlueColor;
    }else {
        cell.title.textColor = [UIColor blackColor];
    }
    //是否学习过
    if (cell.talkGridModel.user_learned == 1) {
        cell.studyImage.hidden = NO;
    }else if(cell.talkGridModel.user_learned == 0){
        cell.studyImage.hidden = YES;
    }
    //买过此课，免费试看隐藏
    if (_isPay){
        cell.freeVideoLogo.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    if ([model.type isEqualToString:@"dir"]) {
        return 35;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    if ([model.type isEqualToString:@"dir"]) {
        IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        //        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
        //        [sectionView addSubview:bottomView];
        //        bottomView.backgroundColor = BackgroundColor;
        sectionView.moreLabel.hidden = YES;
        sectionView.titleLabel.text = model.title;
        return sectionView;
    }
    return nil;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        self.selectedModel = model.children[indexPath.row];
        
    } else if ([model.type isEqualToString:@"lesson"]) {
        self.selectedModel = model;
    }
    //Block回掉换视频
    if (self.actionWithDidSelectedBlock) {
        self.actionWithDidSelectedBlock(self.selectedModel);
    }
   //给服务器发送用户已学习消息
    if (_isPay) {
            //代理执行换视频
            if (self.delegate && [self.delegate respondsToSelector:@selector(lessonPlayerLessonListViewController:TableDidSelectedAction:)]) {
                [self.delegate lessonPlayerLessonListViewController:self TableDidSelectedAction:self.selectedModel];
            }
    }
    [self.tableView reloadData];
}
@end
