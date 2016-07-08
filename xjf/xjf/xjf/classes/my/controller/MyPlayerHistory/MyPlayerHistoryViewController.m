//
//  MyPlayerHistoryViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyPlayerHistoryViewController.h"
#import "TalkGridModel.h"
#import "VideoListCell.h"
#import "IndexSectionView.h"
#import "LessonPlayerViewController.h"
#import "PlayerViewController.h"

@interface MyPlayerHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TablkListModel *tablkListModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dicDate;
@end

@implementation MyPlayerHistoryViewController
static NSString *MyPlayerHistoryCell_id = @"MyPlayerHistoryCell_id";
static CGFloat tableHeaderH = 35;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"播放记录";
    [self initTabelView];
    [self requesData:history method:GET];
}

#pragma mark requestData

- (void)requesData:(APIName *)api method:(RequestMethod)method {
    @weakify(self)
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];

//        NSMutableArray *array = [NSMutableArray array];
//        for (TalkGridModel *model in self.tablkListModel.result.data) {
//            [array addObject: model.user_played_at];
//        }
//        
//        array = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd "];
//            if (obj1 == [NSNull null]) {
//                obj1 = @"0000-00-00";
//            }
//            if (obj2 == [NSNull null]) {
//                obj2 = @"0000-00-00";
//            }
//            NSDate *date1 = [formatter dateFromString:obj1];
//            NSDate *date2 = [formatter dateFromString:obj2];
//            NSComparisonResult result = [date1 compare:date2];
//            return result == NSOrderedAscending;
//        }];
//        for (int i = 0; i < [array count]; i++) {
//            NSLog(@"%@", [array objectAtIndex:i]);
//        }
//

        self.dicDate = [NSMutableDictionary dictionary];
        TalkGridModel *tempModel = [[TalkGridModel alloc] init];
        for (TalkGridModel *model in self.tablkListModel.result.data) {
            if (![[tempModel.user_played_at substringToIndex:10] isEqualToString:[model.user_played_at substringToIndex:10]]) {
                tempModel = model;
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:model];
                [self.dicDate setObject:array forKey:[tempModel.user_played_at substringToIndex:10]];
            } else {
                NSMutableArray *array = self.dicDate[[tempModel.user_played_at substringToIndex:10]];
                [array addObject:model];
            }

        }


        [self.tableView reloadData];
    } failedBlock:^(NSError *_Nullable error) {

    }];
}

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
            initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyPlayerHistoryCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *keys = [self.dicDate allKeys];
    NSString *tempStr = keys[section];
    return [self.dicDate[tempStr] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.dicDate allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyPlayerHistoryCell_id];

    NSArray *keys = [self.dicDate allKeys];
    NSString *tempStr = keys[indexPath.section];
    NSMutableArray *array = self.dicDate[tempStr];
    cell.model = array[indexPath.row];
    if (![cell.model.department isEqualToString:@"dept2"]) {
        cell.teacherName.hidden = NO;
        cell.lessonCount.hidden = NO;
    } else {
        cell.teacherName.hidden = YES;
        cell.lessonCount.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    [sectionView addSubview:bottomView];
    bottomView.backgroundColor = BackgroundColor;
    sectionView.moreLabel.hidden = YES;

    NSArray *keys = [self.dicDate allKeys];
    NSString *tempStr = keys[section];
    sectionView.titleLabel.text = tempStr;
    return sectionView;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *keys = [self.dicDate allKeys];
    NSString *tempStr = keys[indexPath.section];
    NSMutableArray *array = self.dicDate[tempStr];
    TalkGridModel *model = array[indexPath.row];

    if ([model.department isEqualToString:@"dept2"]) {
        PlayerViewController *player = [PlayerViewController new];
        player.talkGridModel = model;
        [self.navigationController pushViewController:player animated:YES];
    } else {
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
//        if ([model.department isEqualToString:@"dept3"]) {
//          
//        } else if ([model.department isEqualToString:@"dept4"]) {
//
//        }
    }

}

/*
 -(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return YES;
 }
 - (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return @"删除";
 }
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return UITableViewCellEditingStyleDelete;
 }
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 //    if (editingStyle == UITableViewCellEditingStyleDelete){
 //        [self PostOrDeleteRequestData:favorite Method:DELETE IndexPath:indexPath];
 //        [self.dataSource removeObjectAtIndex:indexPath.row];
 //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
 //    }
 }
 */

@end
