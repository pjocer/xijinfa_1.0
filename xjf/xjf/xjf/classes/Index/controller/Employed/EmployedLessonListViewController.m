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

@interface EmployedLessonListViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *goodsCount;
@property (nonatomic, strong) EmployedBasisViewController *employedBasisViewController;
@property (nonatomic, strong) EmployedLawsViewController *employedLawsViewController;
@property (nonatomic, strong) EmployedGeneralViewController *employedGeneralViewController;
///基础知识数据
@property (nonatomic, strong) NSMutableArray *dataSource_EmployedBasis;
///法律法规数据
@property (nonatomic, strong) NSMutableArray *dataSource_EmployedLaws;
///全科数据
@property (nonatomic, strong) NSMutableArray *dataSource_EmployedGeneral;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) UIView *selView;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end


@implementation EmployedLessonListViewController
static CGFloat titleH = 35;
static CGFloat selViewH = 3;

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

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

#pragma mark - initMainUI

- (void)initMainUI {
    [self setupTitleScrollView];//创建小scrollview
    [self setupContentScrollView];//创建大scrollview
    [self addChildViewController];//添加子控制器
    [self setupTitle];//根据子视图个数创建小scrollview的按钮

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWITH, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

#pragma mark - 设置头部标题栏

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, 1, SCREENWITH, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleScrollView];
}

#pragma mark - 设置内容

- (void)setupContentScrollView {
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.bounces = NO;
}

#pragma mark - 添加子控制器

- (void)addChildViewController {

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


}

#pragma mark - 设置标题

- (void)setupTitle {
    NSUInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = SCREENWITH / count;
    CGFloat h = titleH;
    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];

        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT15;

        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];

        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];

        if (i == 0) {
            [self chick:btn];
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;

    self.selBackGroundView = [[UIView alloc]
            initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), SCREENWITH, selViewH)];
    self.selBackGroundView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.selBackGroundView];
    //
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selBackGroundView.frame.origin.y, w, selViewH)];
    self.selView.backgroundColor = BlueColor
    [self.view addSubview:self.selView];
    [RACObserve(self.contentScrollView, contentOffset) subscribeNext:^(id x) {
        CGPoint offSet = [x CGPointValue];
        CGFloat percent = offSet.x/SCREENWITH;
        [self.selView setFrame:CGRectMake(percent*SCREENWITH/count, CGRectGetMaxY(self.titleScrollView.frame), SCREENWITH/count, selViewH)];
    }];
}

// 按钮点击
- (void)chick:(UIButton *)btn {
    [self selTitleBtn:btn];
    NSUInteger i = btn.tag;
    CGFloat x = i * SCREENWITH;
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

// 选中按钮
- (void)selTitleBtn:(UIButton *)btn {
    [UIView animateWithDuration:0.3 animations:^{
        self.selView.center = CGPointMake(btn.center.x, self.selBackGroundView.center.y);
    }];
}

- (void)setUpOneChildViewController:(NSUInteger)i {
    CGFloat x = i * SCREENWITH;
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, SCREENWITH, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:vc.view];
}

- (void)setupTitleCenter:(UIButton *)btn {
    CGFloat offset = btn.center.x - SCREENWITH * 0.5;
    //    NSLog(@"center.x:%lf   offset:%lf",btn.center.x,offset);
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - SCREENWITH;
    //    NSLog(@"maxOffset:%lf",maxOffset);
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.contentScrollView.contentOffset.x / SCREENWITH;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


@end
