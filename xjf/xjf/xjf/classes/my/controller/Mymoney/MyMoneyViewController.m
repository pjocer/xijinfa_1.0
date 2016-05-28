//
//  MyMoneyViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "MyMoneyHeaderView.h"
#import "MyOrderViewController.h"
@interface MyMoneyViewController ()

@end

@implementation MyMoneyViewController

static CGFloat MyMoneyHeaderViewH = 155;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"我的钱包";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    MyMoneyHeaderView *headerView = [[MyMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, MyMoneyHeaderViewH)];
    [self.view addSubview:headerView];
    UITapGestureRecognizer *LookOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LookOrder:)];
    [headerView.bottomView addGestureRecognizer:LookOrder];

}

- (void)LookOrder:(UITapGestureRecognizer *)sender
{
    MyOrderViewController *myOrderPage = [MyOrderViewController new];
    [self.navigationController pushViewController:myOrderPage animated:YES];
}


@end
