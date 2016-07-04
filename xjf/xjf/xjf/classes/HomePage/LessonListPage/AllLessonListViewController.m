//
//  AllLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AllLessonListViewController.h"
#import "SearchViewController.h"
#import "HomePageConfigure.h"
#import "SelectedView.h"

@interface AllLessonListViewController ()

@end

@implementation AllLessonListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelectedView];
}

#pragma mark - setControl

#pragma mark  Navigation

- (void)setNavigation {

    switch (self.lessonListPageLessonType) {
        case LessonListPageWikipedia: {
    self.navigationItem.title = @"析金百科";
        }
            break;
        case LessonListPageSchool: {
    self.navigationItem.title = @"析金学堂";
        }
            break;
        case LessonListPageEmployed: {
    self.navigationItem.title = @"析金从业";
        }
            break;
        default:
            break;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"search"]
                                              style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
}

#pragma mark SelectedView

- (void)setSelectedView
{
    SelectedView *selectedView = [[SelectedView alloc] initWithFrame:self.view.frame SelectedViewType:ISSchool];
    [self.view addSubview:selectedView];
    
    selectedView.leftButtonName = @"Left";
    selectedView.rightButtonName = @"Right";
    selectedView.testTableDataSource = @[@"xxxxx",@"xxaaaaxxxxxbb",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd",@"xxxxxbb",@"xxc",@"xd"].mutableCopy;
    selectedView.tableDataSource = @[@"1",@"2",@"3",@"4",@"5"].mutableCopy;
    selectedView.handlerData = ^(id data) {
        //reloadData at here.
        NSLog(@"%@",data);
    };
}


#pragma mark - Actions

#pragma mark Search

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    //导航栏右按钮 搜索
    SearchViewController *searchViewController = [SearchViewController new];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

@end
