//
//  SearchResultController.h
//  xjf
//
//  Created by PerryJ on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    LessonsTable,
    TopicsTable,
    EncyclopediaTable,
    PersonsTable,
    AllTable
} ReloadTableType;

@interface SearchResultController : BaseViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *segmentline;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, strong) NSMutableArray *encyDataSource;
@property (nonatomic, strong) NSMutableArray *lessonsDataSource;
@property (nonatomic, strong) NSMutableArray *topicsDataSource;
@property (nonatomic, strong) NSMutableArray *personsDataSource;
- (void)reloadDataFor:(ReloadTableType)type;
@end
