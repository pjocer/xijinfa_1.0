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
#import "XJMarket.h"
#import "LessonPlayerLessonDescribeViewController.h"
#import "LessonDetailLessonListViewController.h"
#import "LessonDetailTecherDescribeViewController.h"
#import "OrderDetaiViewController.h"

@interface LessonDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) LessonDetailTitleView *lessonDetailTitleView;
///加入购物车按钮
@property (nonatomic, strong) UIButton *addShoppingCart;
///立刻购买按钮
@property (nonatomic, strong) UIButton *nowPay;
///继续学习按钮
@property (nonatomic, strong) UIButton *studing;

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
/// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;
///展示按钮下View
@property (nonatomic, strong) UIView *selView;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) LessonDetailLessonListViewController *lessonDetailLessonListViewController;
@property (nonatomic, strong) LessonPlayerLessonDescribeViewController *lessonPlayerLessonDescribeViewController;
@property (nonatomic, strong) LessonDetailTecherDescribeViewController *lessonDetailTecherDescribeViewController;
@property (nonatomic, strong) UILabel *goodsCount;
@property (nonatomic, strong) LessonDetailListModel *dataSourceModel;
@end


@implementation LessonDetailViewController
static CGFloat titleH = 35;
static CGFloat selViewH = 3;
static CGFloat BottomPayButtonH = 50;
static CGFloat payViewH = 285;

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
    if (self.dataSourceModel != nil) {
        NSString *api = [NSString stringWithFormat:@"%@/%@", self.apiType, self.model.id_];
        [self requestLessonListData:api method:GET];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];

    NSString *api = [NSString stringWithFormat:@"%@/%@", self.apiType, self.model.id_];
    [self requestLessonListData:api method:GET];

}


- (void)requestLessonListData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.dataSourceModel = [[LessonDetailListModel alloc] initWithData:responseData error:nil];
        sSelf.lessonDetailTitleView.model = self.dataSourceModel;
        sSelf.lessonPlayerLessonDescribeViewController.contentText = self.dataSourceModel.result.content;
        if (self.dataSourceModel.result.user_purchased || self.dataSourceModel.result.user_subscribed) {
            self.lessonDetailLessonListViewController.isPay = YES;
        }
        sSelf.lessonDetailLessonListViewController.lessonDetailListModel = self.dataSourceModel;
        [sSelf.lessonDetailLessonListViewController.tableView reloadData];
        sSelf.lessonDetailTecherDescribeViewController.dataSourceModel = self.dataSourceModel;
        [sSelf.lessonDetailTecherDescribeViewController.tableView reloadData];
        //是否购买过此课程
        if (self.dataSourceModel.result.user_purchased || self.dataSourceModel.result.user_subscribed) {
            self.nowPay.hidden = YES;
            self.addShoppingCart.hidden = YES;
            self.studing.hidden = NO;
        } else {
            self.nowPay.hidden = NO;
            self.addShoppingCart.hidden = NO;
            self.studing.hidden = YES;
        }
        [[ZToastManager ShardInstance] hideprogress];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}


#pragma mark - setNavigationBar

- (void)setNavigationBar {
    self.navigationItem.title = @"课程详情";
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
    [self setLessonDetailTitleView];

    [self setupTitleScrollView];//创建小scrollview
    [self setupContentScrollView];//创建大scrollview
    [self addChildViewController];//添加子控制器
    [self setupTitle];//根据子视图个数创建小scrollview的按钮

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWITH, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;

    [self setAddShoppingCartButtonAndNowPayButton];
}

#pragma mark -- setLessonDetailTitleView--

- (void)setLessonDetailTitleView {
    self.lessonDetailTitleView = [[LessonDetailTitleView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.lessonDetailTitleView];
    CGFloat lessonDetailTitleViewHeight;
    if (iPhone5 || iPhone4) {
        lessonDetailTitleViewHeight = 100;
    } else {
        lessonDetailTitleViewHeight = 120;
    }
    self.lessonDetailTitleView.frame = CGRectMake(0, 0, SCREENWITH, lessonDetailTitleViewHeight);
}


#pragma mark --setBottomButtonAboutPay--

- (void)setAddShoppingCartButtonAndNowPayButton {
    self.addShoppingCart = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.addShoppingCart];
    self.addShoppingCart.frame = CGRectMake(0,
            self.view.frame.size.height - BottomPayButtonH - HEADHEIGHT,
            self.view.frame.size.width / 2,
            BottomPayButtonH);
    self.addShoppingCart.backgroundColor = [UIColor orangeColor];
    [self.addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addShoppingCart.tintColor = [UIColor whiteColor];
    self.addShoppingCart.titleLabel.font = FONT15;
    [self.addShoppingCart
            addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];

    self.nowPay = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.nowPay];
    self.nowPay.frame = CGRectMake(CGRectGetMaxX(self.addShoppingCart.frame),
            self.view.frame.size.height - BottomPayButtonH - HEADHEIGHT,
            self.view.frame.size.width / 2,
            BottomPayButtonH);
    self.nowPay.backgroundColor = [UIColor redColor];
    [self.nowPay setTitle:@"立刻购买" forState:UIControlStateNormal];
    self.nowPay.tintColor = [UIColor whiteColor];
    self.nowPay.titleLabel.font = FONT15;
    [self.nowPay addTarget:self action:@selector(nowPay:) forControlEvents:UIControlEventTouchUpInside];

    self.studing = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.studing];
    self.studing.frame = CGRectMake(0,
            self.view.frame.size.height - BottomPayButtonH - HEADHEIGHT,
            self.view.frame.size.width,
            BottomPayButtonH);
    self.studing.backgroundColor = BlueColor;
    [self.studing setTitle:@"继续学习" forState:UIControlStateNormal];
    self.studing.tintColor = [UIColor whiteColor];
    self.studing.titleLabel.font = FONT15;
    [self.studing addTarget:self action:@selector(studing:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark addShoppingCart

- (void)addShoppingCart:(UIButton *)sender {
    if ([[XJMarket sharedMarket] isAlreadyExists:self.model key:XJ_XUETANG_SHOP] || [[XJMarket sharedMarket] isAlreadyExists:self.model key:XJ_CONGYE_PEIXUN_SHOP]) {
        [[ZToastManager ShardInstance] showtoast:@"此商品已添加至购物车"];
    } else {
        [[ZToastManager ShardInstance] showtoast:@"添加购物车成功"];
        if ([self.model.department isEqualToString:@"dept3"]) {
            [[XJMarket sharedMarket] addGoods:@[self.model] key:XJ_XUETANG_SHOP];
        } else if ([self.model.department isEqualToString:@"dept4"]) {
            [[XJMarket sharedMarket] addGoods:@[self.model] key:XJ_CONGYE_PEIXUN_SHOP];
        }

        self.goodsCount.text = [NSString stringWithFormat:@"%ld", [[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] count] + [[[XJMarket sharedMarket] shoppingCartFor:XJ_CONGYE_PEIXUN_SHOP] count]];
        if (self.goodsCount.hidden == YES) {
            self.goodsCount.hidden = NO;
        }
    }
}

#pragma mark nowPay

- (void)nowPay:(UIButton *)sender {
    OrderDetaiViewController *orderDetailPage = [OrderDetaiViewController new];
    orderDetailPage.dataSource = [NSMutableArray arrayWithObject:self.model];
    [self.navigationController pushViewController:orderDetailPage animated:YES];
}

#pragma mark - studing

- (void)studing:(UIButton *)sender {

}

#pragma mark - 设置头部标题栏

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.lessonDetailTitleView.frame) + 1, SCREENWITH, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleScrollView];
}

#pragma mark - 设置内容

- (void)setupContentScrollView {
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH - BottomPayButtonH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.bounces = NO;
}

#pragma mark - 添加子控制器

- (void)addChildViewController {
    self.lessonDetailLessonListViewController = [[LessonDetailLessonListViewController alloc] init];
    self.lessonDetailLessonListViewController.title = @"目录";
    [self addChildViewController:self.lessonDetailLessonListViewController];

    self.lessonPlayerLessonDescribeViewController = [[LessonPlayerLessonDescribeViewController alloc] init];
    self.lessonPlayerLessonDescribeViewController.title = @"课程介绍";
    [self addChildViewController:self.lessonPlayerLessonDescribeViewController];

    self.lessonDetailTecherDescribeViewController = [[LessonDetailTecherDescribeViewController alloc] init];
    self.lessonDetailTecherDescribeViewController.title = @"讲师介绍";
    [self addChildViewController:self.lessonDetailTecherDescribeViewController];
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
