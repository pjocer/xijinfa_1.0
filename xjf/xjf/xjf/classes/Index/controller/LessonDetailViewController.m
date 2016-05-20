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

@interface LessonDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) LessonDetailTitleView *lessonDetailTitleView;
///加入购物车按钮
@property (nonatomic, strong) UIButton *addShoppingCart;
///立刻购买按钮
@property (nonatomic, strong) UIButton *nowPay;

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
/// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;
///展示按钮下View
@property (nonatomic, strong) UIView *selView;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation LessonDetailViewController

static CGFloat  titleH = 35;
static CGFloat  selViewH = 3;

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
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
    
    //
    [self setupTitleScrollView];//创建小scrollview
//    [self setupContentScrollView];//创建大scrollview
//    //
//    [self addChildViewController];//添加子控制器
//    [self setupTitle];//根据子视图个数创建小scrollview的按钮
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWITH, 0);
//    self.contentScrollView.pagingEnabled = YES;
//    self.contentScrollView.showsHorizontalScrollIndicator = NO;
//    self.contentScrollView.delegate = self;
}

#pragma mark -- setLessonDetailTitleView--
- (void)setLessonDetailTitleView
{
    self.lessonDetailTitleView = [[LessonDetailTitleView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.lessonDetailTitleView];
    CGFloat lessonDetailTitleViewHeight;
    if (iPhone5 || iPhone4) {
        lessonDetailTitleViewHeight = 100;
    }else{
        lessonDetailTitleViewHeight = 120;
    }
    [self.lessonDetailTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(lessonDetailTitleViewHeight);
    }];
    
    self.lessonDetailTitleView.model = self.model;
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
    [[XJMarket sharedMarket] addLessons:@[self.model] key:MY_LESSONS_XUETANG];
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.self.lessonDetailTitleView.frame) + 1, SCREENWITH, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}
#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
    self.contentScrollView.bounces = NO;
}
#pragma mark - 添加子控制器
- (void)addChildViewController
{
    LessonDetailLessonListViewController *vc = [[LessonDetailLessonListViewController alloc] init];
    vc.title = @"目录";
    [self addChildViewController:vc];
    
    LessonPlayerLessonDescribeViewController *vc1 = [[LessonPlayerLessonDescribeViewController alloc] init];
    vc1.title = @"课程介绍";
    [self addChildViewController:vc1];
    
    LessonDetailTecherDescribeViewController *vc2 = [[LessonDetailTecherDescribeViewController alloc] init];
    vc2.title = @"讲师介绍";
    [self addChildViewController:vc2];  
}
#pragma mark - 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = SCREENWITH / count;
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
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
        
        if (i == 0)
        {
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    self.selBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), SCREENWITH, selViewH)];
    self.selBackGroundView .backgroundColor = BackgroundColor;
    [self.view addSubview:self.selBackGroundView ];
    
    //
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), w, selViewH)];
    self.selView.backgroundColor = BlueColor
    [self.view addSubview:self.selView];
}
// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * SCREENWITH;
    
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    self.selView.center = CGPointMake(btn.center.x, CGRectGetMaxY(self.titleScrollView.frame) + 1);
}
- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * SCREENWITH;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, SCREENWITH, SCREENHEIGHT - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    
}
- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - SCREENWITH * 0.5;
    //    NSLog(@"center.x:%lf   offset:%lf",btn.center.x,offset);
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - SCREENWITH;
    //    NSLog(@"maxOffset:%lf",maxOffset);
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / SCREENWITH;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end
