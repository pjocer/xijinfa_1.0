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
static CGFloat tableHeaderH = 45;

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
            initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 25) style:UITableViewStylePlain];
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
    ViewRadius(cell, 5);
    
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
    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 45)];
    sectionView.backgroundColor = [UIColor clearColor];
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
