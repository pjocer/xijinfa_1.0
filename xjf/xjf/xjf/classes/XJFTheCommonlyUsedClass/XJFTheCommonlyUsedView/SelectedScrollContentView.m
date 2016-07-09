//
//  SelectedScrollContentView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedScrollContentView.h"

@interface SelectedScrollContentView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIViewController *targetViewController;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *selBackGroundView;
@property (nonatomic, strong) UIView *selView;
@end

@implementation SelectedScrollContentView
static CGFloat titleViewH = 35;
static CGFloat selViewH = 2;
static CGFloat titleViewTopClearance = 1;
static CGFloat animateWithDuration = 0.3;

- (instancetype)initWithFrame:(CGRect)frame
         targetViewController:(UIViewController *)targetViewController
  addChildViewControllerBlock:(void(^)())block{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.targetViewController = targetViewController;
        block();
        [self initMainUI];
    }
    return self;
}

#pragma mark - initMainUI

- (void)initMainUI {
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self setupTitle];
    
    self.contentScrollView.contentSize = CGSizeMake(self.targetViewController.childViewControllers.count * SCREENWITH, 0);
    
}

#pragma mark  setupTitleScrollView

- (void)setupTitleScrollView {
    CGRect rect = CGRectMake(0, titleViewTopClearance, SCREENWITH, titleViewH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleScrollView];
}

#pragma mark  setupContentScrollView

- (void)setupContentScrollView {
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y + selViewH, SCREENWITH, SCREENHEIGHT - y - selViewH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self addSubview:self.contentScrollView];
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

#pragma mark  setupTitle

- (void)setupTitle {
    NSUInteger count = self.targetViewController.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = SCREENWITH / count;
    CGFloat h = titleViewH;
    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.targetViewController.childViewControllers[i];
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT17;
        
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
    [self addSubview:self.selBackGroundView];
    
    self.selView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selBackGroundView.frame.origin.y, w, selViewH)];
    self.selView.backgroundColor = BlueColor;
    [self addSubview:self.selView];
    @weakify(self)
    [RACObserve(self.contentScrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self)
        CGPoint offSet = [x CGPointValue];
        CGFloat percent = offSet.x/SCREENWITH;
        [self.selView setFrame:CGRectMake(percent*SCREENWITH/count, CGRectGetMaxY(self.titleScrollView.frame), SCREENWITH/count, selViewH)];
    }];
}

// chick
- (void)chick:(UIButton *)btn {
    [self selTitleBtn:btn];
    NSUInteger i = btn.tag;
    CGFloat x = i * SCREENWITH;
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

// selTitleBtn
- (void)selTitleBtn:(UIButton *)btn {
    [UIView animateWithDuration:animateWithDuration animations:^{
        self.selView.center = CGPointMake(btn.center.x, self.selBackGroundView.center.y);
    }];
}

- (void)setUpOneChildViewController:(NSUInteger)i {
    CGFloat x = i * SCREENWITH;
    UIViewController *vc = self.targetViewController.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, SCREENWITH, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:vc.view];
}

- (void)setupTitleCenter:(UIButton *)btn {
    CGFloat offset = btn.center.x - SCREENWITH * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - SCREENWITH;
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

#pragma mark - setter

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mark - public Action

- (void)changCurrunViewLocation:(NSInteger)index
{
    CGFloat x = index * SCREENWITH;
    [self setUpOneChildViewController:index];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

@end
