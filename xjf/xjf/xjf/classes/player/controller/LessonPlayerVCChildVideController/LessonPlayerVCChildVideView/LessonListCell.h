//
//  LessonListCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonListCell : UITableViewCell
///课程名字
@property(nonatomic, strong) UILabel *lessonName;
///课程时长
@property(nonatomic, strong) UILabel *lessonTime;
@end
