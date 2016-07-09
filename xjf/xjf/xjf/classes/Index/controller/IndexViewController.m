//
//  IndexViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexConfigure.h"
#import "LessonListViewController.h"
#import "LessonDetailViewController.h"
#import "EmployedViewController.h"
#import "EmployedLessonListViewController.h"
#import "BannerWebViewViewController.h"
#import "BannerModel.h"

@interface IndexViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) TablkListModel *tablkListModel_Lesson;
@property (nonatomic, strong) TeacherListHostModel *teacherListHostModel;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
@end

@implementation IndexViewController

NSString *const BANNER_CELL = @"bannercell";
NSString *const ENTRY_CELL = @"appcell";
NSString *const TALK_CELL = @"talkcell";
NSString *const BAIKE_CELL = @"baikecell";
NSString *const TEACHER_CELL = @"teachercell";
NSString *const COURSE_CELL = @"coursecell";
NSString *const CONGYE_CELL = @"congyecell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_sectionsArray) {
        _sectionsArray = [[NSMutableArray alloc] init];
    }
    _sectionsArray = [@[
            BANNER_CELL,
            ENTRY_CELL,
            TALK_CELL,
            BAIKE_CELL,
            TEACHER_CELL,
            COURSE_CELL] mutableCopy];
    //
    [self extendheadViewFor:Index];
    [self initMainUI];

    [self requestCategoriesTalkGridData:talkGrid method:GET];
    [self requestLessonListApi:coursesProjectLessonDetailList method:GET];
    [self requestTeacherListData:teacherListHot method:GET];
    [self requestProjectListDat:Employed method:GET];
}

- (void)requestCategoriesTalkGridData:(APIName *)talkGridApi
                               method:(RequestMethod)method {

    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:talkGridApi RequestMethod:method];
    //TalkGridData
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableview reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

- (void)requestLessonListApi:(APIName *)lessonListApi
                      method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:lessonListApi RequestMethod:method];

    //tablkListModel_Lesson
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel_Lesson = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableview reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];

}

- (void)requestTeacherListData:(APIName *)teacherApi
                        method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:teacherApi RequestMethod:method];

    //tablkListModel_Lesson
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.teacherListHostModel = [[TeacherListHostModel alloc] initWithData:responseData error:nil];
        [sSelf.tableview reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

//ProjectListByModel
- (void)requestProjectListDat:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
        [sSelf.tableview reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
    }];
}

- (void)initMainUI {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 64)
                                              style:UITableViewStyleGrouped];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

// table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:BANNER_CELL]) {
        return [IndexBannerCell returnCellHeight:nil];
    } else if ([sectionTitle isEqualToString:ENTRY_CELL]) {
        return [IndexAppCell returnCellHeight:nil];
    } else if ([sectionTitle isEqualToString:TALK_CELL]) {
        return [IndexTalkCell returnCellHeight:nil];
    } else if ([sectionTitle isEqualToString:BAIKE_CELL]) {
        return [IndexBaikeCell returnCellHeight:nil];
    } else if ([sectionTitle isEqualToString:TEACHER_CELL]) {
        return [IndexTeacherCell returnCellHeight:nil];
    } else if ([sectionTitle isEqualToString:COURSE_CELL]) {
        return [IndexCourseCell returnCellHeight:nil];
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self.sectionsArray objectAtIndex:section];
    if ([sectionTitle isEqualToString:BANNER_CELL] || [sectionTitle isEqualToString:ENTRY_CELL]) {
        return 0.01;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *sectionTitle = [self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:BANNER_CELL]) {
        IndexBannerCell *cell = (IndexBannerCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexBannerCell"];
        if (cell == nil) {
            cell = [[IndexBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexBannerCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;

    } else if ([sectionTitle isEqualToString:ENTRY_CELL]) {
        IndexAppCell *cell = (IndexAppCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexAppCell"];
        if (cell == nil) {
            cell = [[IndexAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexAppCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;

    } else if ([sectionTitle isEqualToString:TALK_CELL]) {
        IndexTalkCell *cell = (IndexTalkCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexTalkCell"];
        if (cell == nil) {
            cell = [[IndexTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexTalkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:self.tablkListModel key:sectionTitle indexPath:indexPath];
        return cell;

    } else if ([sectionTitle isEqualToString:BAIKE_CELL]) {
        IndexBaikeCell *cell = (IndexBaikeCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexBaikeCell"];
        if (cell == nil) {
            cell = [[IndexBaikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexBaikeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:self.tablkListModel_Lesson key:sectionTitle indexPath:indexPath];
        return cell;

    } else if ([sectionTitle isEqualToString:TEACHER_CELL]) {
        IndexTeacherCell *cell = (IndexTeacherCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexTeacherCell"];
        if (cell == nil) {
            cell = [[IndexTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexTeacherCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:self.teacherListHostModel key:sectionTitle indexPath:indexPath];
        return cell;

    } else if ([sectionTitle isEqualToString:COURSE_CELL]) {
        IndexCourseCell *cell = (IndexCourseCell *) [tableView dequeueReusableCellWithIdentifier:@"IndexCourseCell"];
        if (cell == nil) {
            cell = [[IndexCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexCourseCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v, id obj, id key, NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:self.projectListByModel key:sectionTitle indexPath:indexPath];
        return cell;

    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

- (void)cellAction:(BEventType)type views:(UIView *)v obj:(id)obj key:(id)key indexPath:(NSIndexPath *)indexPath {
    switch (type) {
        case BEventType_Unknown:

            if (indexPath.section == 0) {
                XRCarouselView *carouselView = obj;
                carouselView.imageClickBlock = ^(NSInteger index) {
                    NSLog(@"第%ld张图片被点击", (long) index);
                    BannerWebViewViewController *bannerWebViewViewController = [BannerWebViewViewController new];
                    BannerResultModel *model = (BannerResultModel *) key;
                    bannerWebViewViewController.webHtmlUrl = model.link;
                    [self.navigationController pushViewController:bannerWebViewViewController animated:YES];
                };
            } else if (indexPath.section == 1) {

                if ([key isEqualToString:@"0"]) {
                    WikipediaViewController *wikiPage = [WikipediaViewController new];
                    wikiPage.tablkListModel = self.tablkListModel;
                    [self.navigationController pushViewController:wikiPage animated:YES];
                } else if ([key isEqualToString:@"1"]) {
                    [self.navigationController pushViewController:[LessonViewController new] animated:YES];
                } else if ([key isEqualToString:@"2"]) {
                    //从业培训
                    EmployedViewController *employedViewController = [[EmployedViewController alloc] init];
                    [self.navigationController pushViewController:employedViewController animated:YES];
                } else if ([key isEqualToString:@"3"]) {
                    NSLog(@"%@", obj[3]);
                }

            } else if (indexPath.section == 2) {
                //析金百科
                PlayerViewController *playerPage = [PlayerViewController new];
                TalkGridModel *model = (TalkGridModel *) obj;
                playerPage.talkGridModel = model;
                playerPage.talkGridListModel = self.tablkListModel;
                [self.navigationController pushViewController:playerPage animated:YES];
            } else if (indexPath.section == 3) {
                //析金学堂
                LessonDetailViewController *lessonDetailViewController = [LessonDetailViewController new];
                lessonDetailViewController.model = (TalkGridModel *) obj;
                lessonDetailViewController.apiType = coursesProjectLessonDetailList;
                [self.navigationController pushViewController:lessonDetailViewController animated:YES];
            } else if (indexPath.section == 4) {

            } else if (indexPath.section == 5) {
                //从业培训
                EmployedLessonListViewController *employedLessonListViewController = [[EmployedLessonListViewController alloc] init];
                ProjectList *tempModel = self.projectListByModel.result.data[indexPath.row];

                for (ProjectList *model in tempModel.children) {
                    if ([model.title isEqualToString:@"基础知识"]) {
                        employedLessonListViewController.employedBasisID = model.id;
                    }
                    else if ([model.title isEqualToString:@"法律法规"]) {
                        employedLessonListViewController.employedLawsID = model.id;
                    }
                    else if ([model.title isEqualToString:@"全科"]) {
                        employedLessonListViewController.employedGeneralID = model.id;
                    }
                }
                employedLessonListViewController.employedLessonList = tempModel.title;
                [self.navigationController pushViewController:employedLessonListViewController animated:YES];
            }

            break;
        case BEventType_More: {
            if (indexPath.section == 2) {
                //析金百科更多
                VideolistViewController *videolListPage = [VideolistViewController new];
                videolListPage.title = @"析金百科更多";
                [self.navigationController pushViewController:videolListPage animated:YES];
            } else if (indexPath.section == 3) {
                //析金学堂更多

                LessonListViewController *lessonlListPage = [[LessonListViewController alloc] init];
                lessonlListPage.LessonListTitle = @"析金学堂更多";
                [self.navigationController pushViewController:lessonlListPage animated:YES];
            }
//            
//            IndexMoreViewController *more = [[IndexMoreViewController alloc] init];
//            [self.navigationController pushViewController:more animated:YES];
        }
            break;
    }

}

@end
