//
//  LessonListViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "TalkGridModel.h"
@interface LessonListViewController : BaseViewController
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *LessonListTitle;
@property(nonatomic, strong) TablkListModel *tablkListModel;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end
