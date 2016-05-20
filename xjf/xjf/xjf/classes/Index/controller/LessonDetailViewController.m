//
//  LessonDetailViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailViewController.h"

#import "LessonDetailTitleView.h"
#import "ShoppingCartViewController.h"

@interface LessonDetailViewController ()
///加入购物车按钮
@property (nonatomic, strong) UIButton *addShoppingCart;
///立刻购买按钮
@property (nonatomic, strong) UIButton *nowPay;

@end

@implementation LessonDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    
}


#pragma mark - setNavigationBar
- (void)setNavigationBar
{
    self.navigationItem.title = @"课程详情";
    UIBarButtonItem *shoppingCart = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shoppingCart"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingCartAction:)];
    self.navigationItem.rightBarButtonItem = shoppingCart;
}
///购物车事件
- (void)shoppingCartAction:(UIBarButtonItem *)sender
{
    ShoppingCartViewController *shoppingCartViewController = [ShoppingCartViewController new];
    [self.navigationController pushViewController:shoppingCartViewController animated:YES];
}

#pragma mark - initMainUI
- (void)initMainUI
{
    [self setLessonDetailTitleView];
    [self setAddShoppingCartButtonAndNowPayButton];
}

#pragma mark -- setLessonDetailTitleView--
- (void)setLessonDetailTitleView
{
    LessonDetailTitleView *lessonDetailTitleView = [[LessonDetailTitleView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:lessonDetailTitleView];
    CGFloat lessonDetailTitleViewHeight;
    if (iPhone5 || iPhone4) {
        lessonDetailTitleViewHeight = 100;
    }else{
        lessonDetailTitleViewHeight = 120;
    }
    [lessonDetailTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(lessonDetailTitleViewHeight);
    }];
    
    lessonDetailTitleView.model = self.model;
}



#pragma mark --setBottomButtonAboutPay--
- (void)setAddShoppingCartButtonAndNowPayButton
{
    self.addShoppingCart = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.addShoppingCart];
    self.addShoppingCart.backgroundColor = [UIColor orangeColor];
    [self.addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addShoppingCart.tintColor = [UIColor whiteColor];
    self.addShoppingCart.titleLabel.font = FONT15;
    [self.addShoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    [self.addShoppingCart addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nowPay = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.nowPay];
    self.nowPay.backgroundColor = [UIColor redColor];
    [self.nowPay setTitle:@"立刻购买" forState:UIControlStateNormal];
    self.nowPay.tintColor = [UIColor whiteColor];
    self.nowPay.titleLabel.font = FONT15;
    [self.nowPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    [self.nowPay addTarget:self action:@selector(nowPay:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark addShoppingCart
- (void)addShoppingCart:(UIButton *)sender
{

}
#pragma mark nowPay
- (void)nowPay:(UIButton *)sender
{
    
}

@end
