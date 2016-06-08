//
//  SearchResultController.h
//  xjf
//
//  Created by PerryJ on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "TopicModel.h"
#import "FansFocus.h"
#import "TalkGridModel.h"

typedef enum : NSUInteger {
    LessonsTable = 0,
    TopicsTable,
    EncyclopediaTable,
    PersonsTable,
    AllTable,
    UnKnownType
} ReloadTableType;

@protocol TableViewRefreshDelegate <NSObject>
@optional
- (void)tableViewFooterDidRefresh:(NSString *)url;
- (void)tableViewHeaderDidRefresh;
@end

@interface SearchResultController : BaseViewController
@property (nonatomic, weak) id <TableViewRefreshDelegate>delegate;
@property (nonatomic, strong) TablkListModel *baike_list;
@property (nonatomic, strong) TablkListModel *lesson_list;
@property (nonatomic, strong) TopicModel *topic_list;
@property (nonatomic, strong) FansFocus *person_list;
@property (nonatomic, strong) NSMutableArray *encyDataSource;
@property (nonatomic, strong) NSMutableArray *lessonsDataSource;
@property (nonatomic, strong) NSMutableArray *topicsDataSource;
@property (nonatomic, strong) NSMutableArray *personsDataSource;
@property (nonatomic, copy) APIName *api;//当前Table的搜索API
@property (nonatomic, assign) ReloadTableType type;
- (void)reloadData:(ReloadTableType)type;
- (void)clearDataSource;
- (void)hiddenMJRefresh;
@end
