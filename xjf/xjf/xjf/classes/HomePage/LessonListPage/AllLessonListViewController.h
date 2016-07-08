//
//  AllLessonListViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"

@interface AllLessonListViewController : BaseViewController
typedef NS_OPTIONS(NSInteger, LessonListPageLessonType) {
    LessonListPageWikipedia = 0,
    LessonListPageSchool,
    LessonListPageEmployed
};

@property (nonatomic, assign) LessonListPageLessonType lessonListPageLessonType;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lessonListTitle;
@end
