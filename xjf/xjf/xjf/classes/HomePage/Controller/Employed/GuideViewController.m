//
//  GuideViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"报考指南";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
