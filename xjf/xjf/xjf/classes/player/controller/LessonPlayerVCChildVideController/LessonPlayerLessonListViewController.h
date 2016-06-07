//
//  LessonPlayerLessonListViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonDetailListModel.h"

@class LessonPlayerLessonListViewController;
@protocol LessonPlayerLessonListViewControllerDelegate <NSObject>
- (void)lessonPlayerLessonListViewController:(LessonPlayerLessonListViewController *)vc TableDidSelectedAction:(TalkGridModel *)selectModel;
@end


@interface LessonPlayerLessonListViewController : UIViewController
@property (nonatomic, strong) LessonDetailListModel *lessonDetailListModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, strong) TalkGridModel *selectedModel;
@property (nonatomic, assign) id<LessonPlayerLessonListViewControllerDelegate>delegate;
@property (copy, nonatomic) void (^actionWithDidSelectedBlock)(TalkGridModel* model);
@end
