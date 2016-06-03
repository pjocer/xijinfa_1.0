//
//  LessonDetailLessonListCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonDetailListModel.h"
#import "TalkGridModel.h"
@interface LessonDetailLessonListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *studyImage;
@property (nonatomic, strong) LessonDetailListLessonsModel *lessonDetailListModel;
@property (nonatomic, strong) TalkGridModel *talkGridModel;
@property (nonatomic, strong) UILabel *title;
@end
