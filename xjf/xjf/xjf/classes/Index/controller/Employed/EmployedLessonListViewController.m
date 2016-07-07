//
//  EmployedLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedLessonListViewController.h"
#import "XJMarket.h"
#import "ShoppingCartViewController.h"
#import "EmployedBasisViewController.h"
#import "EmployedLawsViewController.h"
#import "EmployedGeneralViewController.h"
#import "SelectedScrollContentView.h"

@interface EmployedLessonListViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *goodsCount;
@property (nonatomic, strong) EmployedBasisViewController *employedBasisViewController;
@property (nonatomic, strong) EmployedLawsViewController *employedLawsViewController;
@property (nonatomic, strong) EmployedGeneralViewController *employedGeneralViewController;
@end


@implementation EmployedLessonListViewController


- (void)loadView
{
    [super loadView];
    [self setNavigationBar];
    @weakify(self)
    SelectedScrollContentView *selectedScrollContentView = [[SelectedScrollContentView alloc]initWithFrame:self.view.bounds targetViewController:self addChildViewControllerBlock:^{
        @strongify(self)
        self.employedBasisViewController = [[EmployedBasisViewController alloc] init];
        self.employedBasisViewController.title = @"基础知识";
        [self addChildViewController:self.employedBasisViewController];
        self.employedBasisViewController.ID = self.employedBasisID;
        
        self.employedLawsViewController = [[EmployedLawsViewController alloc] init];
        self.employedLawsViewController.title = @"法律法规";
        [self addChildViewController:self.employedLawsViewController];
        self.employedLawsViewController.ID = self.employedLawsID;
        
        self.employedGeneralViewController = [[EmployedGeneralViewController alloc] init];
        self.employedGeneralViewController.title = @"全科";
        [self addChildViewController:self.employedGeneralViewController];
        self.employedGeneralViewController.ID = self.employedGeneralID;
    }];
    self.view = selectedScrollContentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - setNavigationBar

- (void)setNavigationBar {
    self.navigationItem.title = self.employedLessonList;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"shoppingCart"] forState:UIControlStateNormal];
    UIBarButtonItem *barbutton2 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barbutton2;
    [button addTarget:self action:@selector(shoppingCartAction:) forControlEvents:UIControlEventTouchUpInside];

    self.goodsCount = [[UILabel alloc] initWithFrame:CGRectNull];
    [button addSubview:self.goodsCount];
    [self.goodsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.goodsCount.backgroundColor = [UIColor redColor];
    self.goodsCount.layer.masksToBounds = YES;
    self.goodsCount.layer.cornerRadius = 10.f;
    self.goodsCount.textColor = [UIColor whiteColor];
    self.goodsCount.font = FONT15;
    self.goodsCount.textAlignment = NSTextAlignmentCenter;
    if ([[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] count] != 0 || [[[XJMarket sharedMarket] shoppingCartFor:XJ_CONGYE_PEIXUN_SHOP] count] != 0) {
        self.goodsCount.hidden = NO;
        self.goodsCount.text = [NSString stringWithFormat:@"%ld", [[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] count] + [[[XJMarket sharedMarket] shoppingCartFor:XJ_CONGYE_PEIXUN_SHOP] count]];
    } else {
        self.goodsCount.hidden = YES;
    }
}

///购物车事件
- (void)shoppingCartAction:(UIButton *)sender {
    ShoppingCartViewController *shoppingCartViewController = [ShoppingCartViewController new];
    [self.navigationController pushViewController:shoppingCartViewController animated:YES];
}

@end
