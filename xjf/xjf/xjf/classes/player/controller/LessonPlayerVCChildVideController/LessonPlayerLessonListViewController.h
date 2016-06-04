//
//  LessonPlayerLessonListViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonDetailListModel.h"
@interface LessonPlayerLessonListViewController : UIViewController
@property (nonatomic, strong) LessonDetailListModel *lessonDetailListModel;
@property (nonatomic, assign) BOOL isPay;
@end
