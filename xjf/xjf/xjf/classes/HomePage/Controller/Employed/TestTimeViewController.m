//
//  TestTimeViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TestTimeViewController.h"

@interface TestTimeViewController ()

@end

@implementation TestTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"考试时间";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
