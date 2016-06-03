//
//  LessonDetailTecherDescribeViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonDetailListModel.h"
@interface LessonDetailTecherDescribeViewController : UIViewController
@property (nonatomic, strong) LessonDetailListModel *dataSourceModel;
@property (nonatomic, strong) UITableView *tableView;
@end
