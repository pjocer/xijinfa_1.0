//
//  TeacherDetailViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherDetailViewController.h"
#import "TeacherDescriptionViewController.h"
#import "TeacherLessonsViewController.h"
#import "TeacherEmployedViewController.h"
#import "TeacherDetailHeaderView.h"
@interface TeacherDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) TeacherDetailHeaderView *teacherDetailHeaderView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) TeacherDescriptionViewController *teacherDescriptionViewController;
@property (nonatomic, strong) TeacherLessonsViewController *teacherLessonsViewController;
@property (nonatomic, strong) TeacherEmployedViewController *teacherEmployedViewController;
@property(nonatomic, strong) NSMutableArray *buttons;
@property(nonatomic, strong) UIView *selBackGroundView;
@property(nonatomic, strong) UIView *selView;
@end

@implementation TeacherDetailViewController
static CGFloat titleH = 35;
static CGFloat selViewH = 3;
static CGFloat BottomPayButtonH = 50;


- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"讲师详情";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

#pragma mark - initMainUI

- (void)initMainUI {
    [self setTeacherDetailHeaderView];
    
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
#pragma mark -- setLessonDetailTitleView--

- (void)setTeacherDetailHeaderView {
    self.teacherDetailHeaderView = [[TeacherDetailHeaderView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.teacherDetailHeaderView];
    CGFloat teacherDetailHeaderViewHeight;
    if (iPhone5 || iPhone4) {
        teacherDetailHeaderViewHeight = 100;
    } else {
        teacherDetailHeaderViewHeight = 120;
    }
    self.teacherDetailHeaderView.frame = CGRectMake(0, 0, SCREENWITH, teacherDetailHeaderViewHeight);
//    self.teacherDetailHeaderView.model = self.model;
}

#pragma mark - 设置头部标题栏

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.teacherDetailHeaderView.frame) + 1, SCREENWITH, titleH);
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
    self.teacherDescriptionViewController = [[TeacherDescriptionViewController alloc] init];
    self.teacherDescriptionViewController.title = @"讲师简介";
    [self addChildViewController:self.teacherDescriptionViewController];
    
    self.teacherLessonsViewController = [[TeacherLessonsViewController alloc] init];
    self.teacherLessonsViewController.title = @"析金学堂";
    [self addChildViewController:self.teacherLessonsViewController];

    self.teacherEmployedViewController = [[TeacherEmployedViewController alloc] init];
    self.teacherEmployedViewController.title = @"析金从业";
    [self addChildViewController:self.teacherEmployedViewController];
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
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), w, selViewH)];
    self.selView.backgroundColor = BlueColor
    [self.view addSubview:self.selView];
    
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
        self.selView.center = CGPointMake(btn.center.x, CGRectGetMaxY(self.titleScrollView.frame) + 1);
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



@end
