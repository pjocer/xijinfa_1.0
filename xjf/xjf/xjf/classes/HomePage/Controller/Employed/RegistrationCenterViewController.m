//
//  RegistrationCenterViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RegistrationCenterViewController.h"

@interface RegistrationCenterViewController ()

@end

@implementation RegistrationCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"选课中心";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
