//
//  PlayerBaseViewController.m
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerBaseViewController.h"

@interface PlayerBaseViewController ()

@end

@implementation PlayerBaseViewController

#pragma mark- viewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    ;
}

#pragma mark- viewWillDisappear

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

@end
