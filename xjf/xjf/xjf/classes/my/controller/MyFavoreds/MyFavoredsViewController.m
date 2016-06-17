//
//  MyFavoredsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyFavoredsViewController.h"
#import "MyFavoredsSchoolViewController.h"
#import "MyFavoredsEmployedViewController.h"
#import "MyFavoredsWikiViewController.h"
#import "TalkGridModel.h"

@interface MyFavoredsViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) MyFavoredsWikiViewController *myFavoredsWikiViewController;
@property (nonatomic, strong) MyFavoredsSchoolViewController *myFavoredsSchoolViewController;
@property (nonatomic, strong) MyFavoredsEmployedViewController *myFavoredsEmployedViewController;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) UIView *selView;
///百科数据
@property (nonatomic, strong) NSMutableArray *dataSource_MyWikiView;
///学堂数据
@property (nonatomic, strong) NSMutableArray *dataSource_MyFavoredsSchoolView;
///从业数据
@property (nonatomic, strong) NSMutableArray *dataSource_myFavoredsEmployed;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end


@implementation MyFavoredsViewController
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
    self.navigationItem.title = @"我的收藏";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self requestCategoriesTalkGridData:favorite method:GET];
}

- (void)requestCategoriesTalkGridData:(APIName *)talkGridApi
                               method:(RequestMethod)method {
    self.dataSource_MyWikiView = [NSMutableArray array];
    self.dataSource_myFavoredsEmployed = [NSMutableArray array];
    self.dataSource_MyFavoredsSchoolView = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:talkGridApi RequestMethod:method];
    [[ZToastManager ShardInstance] showprogress];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        //百科
        for (TalkGridModel *model in self.tablkListModel.result.data) {
            if ([model.type isEqualToString:@"course"] && [model.department isEqualToString:@"dept2"]) {
                [sSelf.dataSource_MyWikiView addObject:model];
            }
        }
        sSelf.myFavoredsWikiViewController.dataSource = self.dataSource_MyWikiView;
        [sSelf.myFavoredsWikiViewController.tableView reloadData];
        //学堂
        for (TalkGridModel *model in self.tablkListModel.result.data) {
            if ([model.type isEqualToString:@"course"] && [model.department isEqualToString:@"dept3"]) {
                [sSelf.dataSource_MyFavoredsSchoolView addObject:model];
            }
        }
        sSelf.myFavoredsSchoolViewController.dataSource = self.dataSource_MyFavoredsSchoolView;
        [sSelf.myFavoredsSchoolViewController.tableView reloadData];
        //从业
        for (TalkGridModel *model in self.tablkListModel.result.data) {
            if ([model.type isEqualToString:@"course"] && [model.department isEqualToString:@"dept4"]) {
                [sSelf.dataSource_myFavoredsEmployed addObject:model];
            }
        }
        sSelf.myFavoredsEmployedViewController.dataSource = self.dataSource_myFavoredsEmployed;
        [sSelf.myFavoredsEmployedViewController.tableView reloadData];

        [[ZToastManager ShardInstance] hideprogress];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
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

    self.myFavoredsWikiViewController = [[MyFavoredsWikiViewController alloc] init];
    self.myFavoredsWikiViewController.title = @"析金百科";
    [self addChildViewController:self.myFavoredsWikiViewController];

    self.myFavoredsSchoolViewController = [[MyFavoredsSchoolViewController alloc] init];
    self.myFavoredsSchoolViewController.title = @"析金学堂";
    [self addChildViewController:self.myFavoredsSchoolViewController];

    self.myFavoredsEmployedViewController = [[MyFavoredsEmployedViewController alloc] init];
    self.myFavoredsEmployedViewController.title = @"从业培训";
    [self addChildViewController:self.myFavoredsEmployedViewController];
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
