//
//  SearchResultController.m
//  xjf
//
//  Created by PerryJ on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchResultController.h"
#import "SearchSectionTwo.h"
#import "BaikeCell.h"
#import "UIImageView+WebCache.h"
#import "CommentDetailHeader.h"
#import "FansCell.h"
#import <MJRefresh/MJRefresh.h>
#import "TopicDetailViewController.h"
#import "XJAccountManager.h"
#import "LessonDetailViewController.h"
#import "UserInfoController.h"
#import "UITableViewCell+AvatarEnabled.h"

@interface SearchResultController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *segmentline;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) UITableView *encyclopedia;
@property (nonatomic, strong) UITableView *lessons;
@property (nonatomic, strong) UITableView *topics;
@property (nonatomic, strong) UITableView *persons;
@end

@implementation SearchResultController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ;
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView {
    [super loadView];
    [self handleDopant];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.header];
    [self.scrollView addSubview:self.encyclopedia];
    [self.scrollView addSubview:self.lessons];
    [self.scrollView addSubview:self.topics];
    [self.scrollView addSubview:self.persons];
    [self handleRACResult];
}

- (void)handleDopant {
    self.tableViews = [NSMutableArray arrayWithCapacity:4];
    [self.tableViews addObject:self.encyclopedia];
    [self.tableViews addObject:self.lessons];
    [self.tableViews addObject:self.topics];
    [self.tableViews addObject:self.persons];
    self.encyDataSource = [NSMutableArray array];
    self.topicsDataSource = [NSMutableArray array];
    self.lessonsDataSource = [NSMutableArray array];
    self.personsDataSource = [NSMutableArray array];
    _type = EncyclopediaTable;
}

- (void)handleRACResult {
    RAC(_segmentline, frame) = [RACObserve(_scrollView, contentOffset) map:^id(id x) {
        CGPoint point = [x CGPointValue];
        CGFloat percent = point.x / SCREENWITH;
        _api = percent == 0 ? search_baike : (percent == 1 ? search_lesson : (percent == 2 ? search_topic : (percent == 3 ? search_person : search_baike)));
        _type = percent == 0 ? EncyclopediaTable : (percent == 1 ? LessonsTable : (percent == 2 ? TopicsTable : (percent == 3 ? PersonsTable : EncyclopediaTable)));
        CGRect frame = CGRectMake(SCREENWITH / 4 * percent, 32, SCREENWITH / 4, 3);
        return [NSValue valueWithCGRect:frame];
    }];
    for (UIButton *button in self.buttons) {
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            [_scrollView setContentOffset:CGPointMake(SCREENWITH * (x.tag - 700), 35) animated:YES];
        }];
    }
}

- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _header.backgroundColor = [UIColor whiteColor];
        [_header addSubview:self.segmentline];
        [_header addShadow];
        self.buttons = [NSMutableArray arrayWithCapacity:4];
        NSArray *titles = @[@"百科", @"课程", @"话题", @"找人"];
        for (int i = 0; i < 4; i++) {
            CGFloat width = SCREENWITH / 4;
            CGFloat height = 18;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 8, width, height)];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
            button.titleLabel.font = FONT15;
            button.tag = 700 + i;
            [_header addSubview:button];
            [self.buttons addObject:button];
        }
    }
    return _header;
}

- (UILabel *)segmentline {
    if (!_segmentline) {
        _segmentline = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREENWITH / 4, 3)];
        _segmentline.backgroundColor = [UIColor xjfStringToColor:@"#0061b0"];
    }
    return _segmentline;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWITH, SCREENHEIGHT - 35 - 64)];
        _scrollView.contentSize = CGSizeMake(4 * SCREENWITH, SCREENHEIGHT - 35 - 64);
        _scrollView.backgroundColor = BackgroundColor;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UITableView *)encyclopedia {
    if (!_encyclopedia) {
        _encyclopedia = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 35 - 64) style:UITableViewStylePlain];
        _encyclopedia.delegate = self;
        _encyclopedia.dataSource = self;
        _encyclopedia.backgroundColor = [UIColor clearColor];
        _encyclopedia.separatorStyle = UITableViewCellSeparatorStyleNone;
        _encyclopedia.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_encyDataSource removeAllObjects];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewHeaderDidRefresh)]) {
                [self.delegate tableViewHeaderDidRefresh];
            }
        }];
        _encyclopedia.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewFooterDidRefresh:)]) {
                [self.delegate tableViewFooterDidRefresh:_baike_list.result.next_page_url];
            }
        }];
        [_encyclopedia registerNib:[UINib nibWithNibName:@"BaikeCell" bundle:nil] forCellReuseIdentifier:@"BaikeCell"];
    }
    return _encyclopedia;
}

- (UITableView *)lessons {
    if (!_lessons) {
        _lessons = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH, 0, SCREENWITH, SCREENHEIGHT - 35 - 64) style:UITableViewStylePlain];
        _lessons.delegate = self;
        _lessons.dataSource = self;
        _lessons.backgroundColor = [UIColor clearColor];
        _lessons.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lessons.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_lessonsDataSource removeAllObjects];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewHeaderDidRefresh)]) {
                [self.delegate tableViewHeaderDidRefresh];
            }
        }];
        _lessons.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewFooterDidRefresh:)]) {
                [self.delegate tableViewFooterDidRefresh:_lesson_list.result.next_page_url];
            }
        }];
        [_lessons registerNib:[UINib nibWithNibName:@"SearchSectionTwo" bundle:nil] forCellReuseIdentifier:@"SearchSectionTwo"];
    }
    return _lessons;
}

- (UITableView *)topics {
    if (!_topics) {
        _topics = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH * 2, 0, SCREENWITH, SCREENHEIGHT - 35 - 64) style:UITableViewStylePlain];
        _topics.delegate = self;
        _topics.dataSource = self;
        _topics.backgroundColor = [UIColor clearColor];
        _topics.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topics.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_topicsDataSource removeAllObjects];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewHeaderDidRefresh)]) {
                [self.delegate tableViewHeaderDidRefresh];
            }
        }];
        _topics.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewFooterDidRefresh:)]) {
                [self.delegate tableViewFooterDidRefresh:_topic_list.result.next_page_url];
            }
        }];
        [_topics registerNib:[UINib nibWithNibName:@"CommentDetailHeader" bundle:nil] forCellReuseIdentifier:@"CommentDetailHeader"];
    }
    return _topics;
}

- (UITableView *)persons {
    if (!_persons) {
        _persons = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH * 3, 0, SCREENWITH, SCREENHEIGHT - 35 - 64) style:UITableViewStylePlain];
        _persons.delegate = self;
        _persons.dataSource = self;
        _persons.backgroundColor = [UIColor clearColor];
        _persons.separatorStyle = UITableViewCellSeparatorStyleNone;
        _persons.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_personsDataSource removeAllObjects];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewHeaderDidRefresh)]) {
                [self.delegate tableViewHeaderDidRefresh];
            }
        }];
        _persons.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewFooterDidRefresh:)]) {
                [self.delegate tableViewFooterDidRefresh:_person_list.result.next_page_url];
            }
        }];
        [_persons registerNib:[UINib nibWithNibName:@"FansCell" bundle:nil] forCellReuseIdentifier:@"FansCell"];
    }
    return _persons;
}

- (void)clearDataSource {
    [self.topicsDataSource removeAllObjects];
    [self.encyDataSource removeAllObjects];
    [self.personsDataSource removeAllObjects];
    [self.lessonsDataSource removeAllObjects];
}

- (void)reloadData:(ReloadTableType)type {
    switch (type) {
        case LessonsTable: {
            [self.lessons reloadData];
        }
            break;
        case TopicsTable: {
            [self.topics reloadData];
        }
            break;
        case EncyclopediaTable: {
            [self.encyclopedia reloadData];
        }
            break;
        case PersonsTable: {
            [self.persons reloadData];
        }
            break;
        case AllTable: {
            for (UITableView *tableView in self.tableViews) {
                [tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}

- (void)hiddenMJRefresh {
    switch (_type) {
        case LessonsTable: {
            [self hiddenMJRefresh:self.lessons];
        }
            break;
        case TopicsTable: {
            [self hiddenMJRefresh:self.topics];
        }
            break;
        case EncyclopediaTable: {
            [self hiddenMJRefresh:self.encyclopedia];
        }
            break;
        case PersonsTable: {
            [self hiddenMJRefresh:self.persons];
        }
            break;
        case AllTable: {
            for (UITableView *tableView in self.tableViews) {
                [self hiddenMJRefresh:tableView];
            }
        }
            break;
        default:
            break;
    }
}

- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.encyclopedia) {
        return self.encyDataSource.count ?: 0;
    } else if (tableView == self.topics) {
        return self.topicsDataSource.count ?: 0;
    } else if (tableView == self.lessons) {
        return self.lessonsDataSource.count ?: 0;
    } else {
        return self.personsDataSource.count ?: 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.encyclopedia) {
        TalkGridModel *model = self.encyDataSource.count > 0 ? [self.encyDataSource objectAtIndex:indexPath.row] : nil;
        BaikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaikeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model) {
            if (model.cover && model.cover.count > 0) {
                TalkGridCover *tempCover = model.cover.firstObject;
                [cell.avatar sd_setImageWithURL:[NSURL URLWithString:tempCover.url]];
            }
            cell.title.text = model.title;
            cell.everWatched.text = [NSString stringWithFormat:@"%@人看过", model.video_view];
        }
        return cell;
    } else if (tableView == self.topics) {
        TopicDataModel *model = self.topicsDataSource.count > 0 ? [self.topicsDataSource objectAtIndex:indexPath.row] : nil;
        CommentDetailHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailHeader" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model) {
            cell.model = model;
        }
        cell.avatarEnabled = ![model.user.id isEqualToString:[[XJAccountManager defaultManager] user_id]];
        return cell;
    } else if (tableView == self.lessons) {
        TalkGridModel *model = self.lessonsDataSource.count > 0 ? [self.lessonsDataSource objectAtIndex:indexPath.row] : nil;
        SearchSectionTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSectionTwo" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model) {
            cell.model = model;
        }
        return cell;
    } else {
        UserInfoModel *model = self.personsDataSource.count > 0 ? [self.personsDataSource objectAtIndex:indexPath.row] : nil;
        FansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model) {
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            cell.nickname.text = model.nickname;
            cell.summary.text = model.quote;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topics) {
        TopicDataModel *model = self.topicsDataSource.count > 0 ? [self.topicsDataSource objectAtIndex:indexPath.row] : nil;
        return model ? [self cellHeight:model] : 150;
    } else {
        return 101;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *current = getCurrentDisplayController();
    if (tableView == self.encyclopedia) {
        NSLog(@"encylopedia");
    } else if (tableView == self.topics) {
        TopicDetailViewController *controller = [[TopicDetailViewController alloc] init];
        TopicDataModel *model = [self.topicsDataSource objectAtIndex:indexPath.row];
        controller.topic_id = model.id;
        [current.navigationController pushViewController:controller animated:YES];
    } else if (tableView == self.lessons) {
        LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
        lessonDetailViewController.model = [self.lessonsDataSource objectAtIndex:indexPath.row];
        if ([lessonDetailViewController.model.department isEqualToString:@"dept3"]) {
            lessonDetailViewController.apiType = coursesProjectLessonDetailList;
        } else if ([lessonDetailViewController.model.department isEqualToString:@"dept4"]) {
            lessonDetailViewController.apiType = EmployedLessonDetailList;
        }
        [current.navigationController pushViewController:lessonDetailViewController animated:YES];
    } else {
        UserInfoModel *model = [self.personsDataSource objectAtIndex:indexPath.row];
        UserInfoController *ta = [[UserInfoController alloc] initWithUserType:Ta userInfo:model];
        [current.navigationController pushViewController:ta animated:YES];
    }
}

- (CGFloat)cellHeight:(TopicDataModel *)model {
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.content width:SCREENWITH - 20 fontsize:15];
    CGFloat height = 10 + 40 + 10 + contentHeight;
    if (model.taxonomy_tags.count > 0) {
        CGFloat all = 0;
        CGFloat alll = 0;
        CGFloat tap = 10;
        NSMutableArray *labels = [NSMutableArray array];
        for (CategoryLabel *label in model.taxonomy_tags) {
            [labels addObject:label.title];
        }
        for (int i = 0; i < labels.count; i++) {
            NSString *title = [NSString stringWithFormat:@"#%@#", labels[i]];
            CGSize size = [title sizeWithFont:FONT12 constrainedToSize:CGSizeMake(SCREENWITH, 14) lineBreakMode:1];
            all = all + tap + size.width;
            if (all <= SCREENWITH) {
                return height + 44;
            } else if (all <= SCREENWITH * 2 && all > SCREENWITH) {
                alll = alll + tap + size.width;
                if (alll <= SCREENWITH) {
                    return height + 68;
                } else {
                    continue;
                }
            }
        }
    } else {
        return height + 10 + 10;
    }
    return height + 10 + 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
