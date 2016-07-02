//
//  TestLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TestLessonListViewController.h"
#import "SelectedView.h"

@interface TestLessonListViewController ()

@end

@implementation TestLessonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
