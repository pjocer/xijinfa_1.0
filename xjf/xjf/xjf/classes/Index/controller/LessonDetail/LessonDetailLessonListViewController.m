//
//  LessonDetailLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailLessonListViewController.h"
#import "LessonDetailLessonListCell.h"
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
//    if (_isPay) {
//        self.tableView.tableHeaderView = [[LessonDetailHaveToPayHeaderView alloc]
//                initWithFrame:CGRectMake(0, 0, SCREENWITH, 36)];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    }
//    else {
//        self.tableView.tableHeaderView = [[LessonDetailNoPayHeaderView alloc]
//                initWithFrame:CGRectMake(0, 0, SCREENWITH, rowHeight)];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    }

}

#pragma mark TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lessonDetailListModel.result.lessons_menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
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
//        cell.studyImage.hidden = YES;
    }
    cell.isPay = _isPay;
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
- (void)lessonDetailLessonListCellJudge:(LessonDetailLessonListCell *)cell {
    //是否免费试看
    if ([cell.talkGridModel.package containsObject:@"visitor"]) {
//        cell.freeVideoLogo.hidden = NO;
    } else {
//        cell.freeVideoLogo.hidden = YES;
    }
    //是否收藏
    if (cell.talkGridModel.user_favored) {
        cell.favorites.image = [UIImage imageNamed:@"iconFavoritesOn"];
    } else {
        cell.favorites.image = nil;
    }
    //是否学习过
    if (cell.talkGridModel.user_learned == 1) {
//        cell.studyImage.hidden = NO;
    } else if (cell.talkGridModel.user_learned == 0) {
//        cell.studyImage.hidden = YES;
    }
    //买过此课，免费试看隐藏
    if (_isPay) {
//        cell.freeVideoLogo.hidden = YES;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    if ([model.type isEqualToString:@"dir"]) {
        return 35;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
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

    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        TalkGridModel *tempModel = model.children[indexPath.row];
        if (!_isPay && ![tempModel.package containsObject:@"visitor"]) {
            [[ZToastManager ShardInstance] showtoast:@"只有购买后才可以观看哦"];
        } else {
            [self cellPuchAction:tempModel];
        }
    } else if ([model.type isEqualToString:@"lesson"]) {
        if (!_isPay && ![model.package containsObject:@"visitor"]) {
            [[ZToastManager ShardInstance] showtoast:@"只有购买后才可以观看哦"];
        } else {
            [self cellPuchAction:model];
        }
    }
}

- (void)cellPuchAction:(TalkGridModel *)model {
    LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
    lessonPlayerViewController.lessonDetailListModel = self.lessonDetailListModel;
    lessonPlayerViewController.lesssonID = self.lessonDetailListModel.result.id;
    lessonPlayerViewController.playTalkGridModel = model;
    //给服务器发送用户已学习消息
    if (_isPay) {
        [self sendUserLearendMessage:user_learnedApi Method:POST ByModel:model];
    }
    [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
}

- (void)sendUserLearendMessage:(APIName *)api Method:(RequestMethod)method ByModel:(TalkGridModel *)model {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
            @{@"id" : [NSString stringWithFormat:@"%@", model.id_],
                    @"type" : [NSString stringWithFormat:@"%@", model.type],
                    @"department" : [NSString stringWithFormat:@"%@", model.department],
                    @"status" : @"1"}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {

    }                  failedBlock:^(NSError *_Nullable error) {

    }];
}
@end
