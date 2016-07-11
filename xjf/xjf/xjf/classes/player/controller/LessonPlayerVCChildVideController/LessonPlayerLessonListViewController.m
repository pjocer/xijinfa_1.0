//
//  LessonPlayerLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonListViewController.h"
#import "LessonDetailLessonListCell.h"
#import "IndexSectionView.h"
#import "OrderDetaiViewController.h"

@interface LessonPlayerLessonListViewController () <UITableViewDelegate, UITableViewDataSource,LessonDetailLessonListCellDelegate>

@end

@implementation LessonPlayerLessonListViewController
static NSString *LessonListCell_id = @"LessonListCell_id";
static CGFloat rowHeight = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    if (self.lessonDetailListModel.result.user_purchased || self.lessonDetailListModel.result.user_subscribed) {
        self.isPay = YES;
    }
    [self initTabelView];
}


#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = rowHeight;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[LessonDetailLessonListCell class]
           forCellReuseIdentifier:LessonListCell_id];
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
    LessonDetailLessonListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonListCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    if (!_isPay) {
//        cell.studyImage.hidden = YES;
    }
    cell.isPay = _isPay;
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        TalkGridModel *tempModel = model.children[indexPath.row];
        cell.talkGridModel = tempModel;
        [self lessonDetailLessonListCellJudge:cell indexPath:indexPath];
    } else if ([model.type isEqualToString:@"lesson"]) {
        cell.talkGridModel = model;
        [self lessonDetailLessonListCellJudge:cell indexPath:indexPath];
    }
    return cell;
}

///Cell 判断性操作
- (void)lessonDetailLessonListCellJudge:(LessonDetailLessonListCell *)cell indexPath:(NSIndexPath *)indexpatch {
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
    //是否是正在观看的课程
    if ([cell.talkGridModel.id_ isEqualToString:self.selectedModel.id_]) {
        cell.title.textColor = BlueColor;
    } else {
        cell.title.textColor = [UIColor blackColor];
    }

    //是否学习过
    if (cell.talkGridModel.user_learned == 1) {
//        cell.studyImage.hidden = NO;
    } else if (cell.talkGridModel.user_learned == 0) {
//        cell.studyImage.hidden = YES;
    }
    //买过此套课，price隐藏
    if (_isPay) {
        cell.lessonPrice.hidden = YES;
    }else{
        cell.lessonPrice.hidden = NO;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    if ([model.type isEqualToString:@"dir"]) {
        return 35;
    }else{
        if (section == 0) {
            return 10;
        }else{
            return 0.01;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[section];
    if ([model.type isEqualToString:@"dir"]) {
        IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        sectionView.moreLabel.hidden = YES;
        sectionView.titleLabel.text = model.title;
        sectionView.backgroundColor = [UIColor clearColor];
        return sectionView;
    }
    return nil;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TalkGridModel *model = self.lessonDetailListModel.result.lessons_menu[indexPath.section];
    if ([model.type isEqualToString:@"dir"]) {
        self.selectedModel = model.children[indexPath.row];

    } else if ([model.type isEqualToString:@"lesson"]) {
        self.selectedModel = model;
    }

//    if (!_isPay && ![self.selectedModel.package containsObject:@"visitor"]) {
//        [[ZToastManager ShardInstance] showtoast:@"只有购买后才可以观看哦"];
//    } else {
        //Block回掉换视频
        if (self.actionWithDidSelectedBlock) {
            self.actionWithDidSelectedBlock(self.selectedModel);
        }
//    }

    //给服务器发送用户已学习消息
    if (_isPay) {
        if (self.delegate && [self.delegate respondsToSelector:
                @selector(lessonPlayerLessonListViewController:TableDidSelectedAction:)]) {
            [self.delegate lessonPlayerLessonListViewController:self TableDidSelectedAction:self.selectedModel];
        }
    }
    [self.tableView reloadData];
}

///lessonDetailLessonListCell PriceButtonPushOrderDetail

- (void)lessonDetailLessonListCell:(LessonDetailLessonListCell *)cell PriceButtonPushOrderDetail:(TalkGridModel *)selectModel
{
    if (!selectModel.user_paid) {
        OrderDetaiViewController *orderDetaiViewController = [OrderDetaiViewController new];
        orderDetaiViewController.dataSource = [NSMutableArray arrayWithObject:selectModel];
        [self.navigationController pushViewController:orderDetaiViewController animated:YES];
    }
}

@end
