//
//  MyMoneyViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "MyMoneyHeaderView.h"
@interface MyMoneyViewController ()

@end

@implementation MyMoneyViewController

static CGFloat MyMoneyHeaderViewH = 155;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title = @"我的钱包";
    MyMoneyHeaderView *headerView = [[MyMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, MyMoneyHeaderViewH)];
    [self.view addSubview:headerView];
    UITapGestureRecognizer *LookOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LookOrder:)];
    [headerView.bottomView addGestureRecognizer:LookOrder];

}

- (void)LookOrder:(UITapGestureRecognizer *)sender
{
    
}


@end
