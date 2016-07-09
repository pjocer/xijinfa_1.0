//
//  MyLessonsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyLessonsViewController.h"
#import "SelectedScrollContentView.h"
#import "AllLessonListViewController.h"

@interface MyLessonsViewController ()

@end

@implementation MyLessonsViewController

- (void)loadView
{
    [super loadView];
    @weakify(self)
    SelectedScrollContentView *selectedScrollContentView = [[SelectedScrollContentView alloc]initWithFrame:self.view.bounds targetViewController:self addChildViewControllerBlock:^{
        @strongify(self)
        AllLessonListViewController *school = [[AllLessonListViewController alloc] init];
        school.title = @"析金学堂";
        school.lessonListPageLessonType = LessonListPageSchool;
        school.isMyLessonsList = YES;
        [self addChildViewController:school];
        
        AllLessonListViewController *employed = [[AllLessonListViewController alloc] init];
        employed.title = @"析金从业";
        employed.lessonListPageLessonType = LessonListPageEmployed;
        employed.isMyLessonsList = YES;
        [self addChildViewController:employed];
    }];
    self.view = selectedScrollContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的课程";
}

@end
