//
//  MyFavoredsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyFavoredsViewController.h"
#import "SelectedScrollContentView.h"
#import "AllLessonListViewController.h"

@interface MyFavoredsViewController () <UIScrollViewDelegate>

@end


@implementation MyFavoredsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}


#pragma mark - initMainUI

- (void)initMainUI {
    self.navigationItem.title = @"我的收藏";
    
    @weakify(self)
    SelectedScrollContentView *selectedScrollContentView = [[SelectedScrollContentView alloc]initWithFrame:self.view.bounds targetViewController:self addChildViewControllerBlock:^{
        @strongify(self)

        AllLessonListViewController *wiki = [AllLessonListViewController new];
        wiki.title = @"析金百科";
        wiki.lessonListPageLessonType = LessonListPageWikipedia;
        wiki.isFavoredsList = YES;
        [self addChildViewController:wiki];
        
        AllLessonListViewController *school = [[AllLessonListViewController alloc] init];
        school.title = @"析金学堂";
        school.lessonListPageLessonType = LessonListPageSchool;
        school.isFavoredsList = YES;
        [self addChildViewController:school];
        
        AllLessonListViewController *employed = [[AllLessonListViewController alloc] init];
        employed.title = @"析金从业";
        employed.lessonListPageLessonType = LessonListPageEmployed;
        employed.isFavoredsList = YES;
        [self addChildViewController:employed];

    }];
    self.view = selectedScrollContentView;

}

@end
