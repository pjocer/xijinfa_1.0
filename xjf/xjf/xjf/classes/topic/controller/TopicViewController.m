//
//  TopicViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicConfigure.h"

@interface TopicViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *bottom;
@property (nonatomic, strong) UIButton *q_a;
@property (nonatomic, strong) UIButton *all;
@property (nonatomic, strong) UIButton *diss;
@property (nonatomic, assign) NSInteger offSet;
@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self extendheadViewFor:Topic];
    self.nav_title = @"话题";
    [self initMainUI];
}

- (void)initMainUI {
    [self.view addSubview:self.header];
    [self.view addSubview:self.scrollView];
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.header.frame), SCREENWITH, SCREENHEIGHT-35-HEADHEIGHT-kTabBarH)];
        _scrollView.contentSize = CGSizeMake(3*SCREENWITH, CGRectGetHeight(_scrollView.bounds));
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.delegate = self;
        UITableView *a = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        a.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:a];
        UITableView *b = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        b.backgroundColor = [UIColor greenColor];
        [_scrollView addSubview:b];
        UITableView *c = [[UITableView alloc] initWithFrame:CGRectMake(2*SCREENWITH, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        c.backgroundColor = [UIColor blueColor];
        [_scrollView addSubview:c];
    }
    return _scrollView;
}

-(UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREENWITH, 35)];
        _header.backgroundColor = [UIColor whiteColor];
        _q_a = [UIButton buttonWithType:UIButtonTypeCustom];
        _q_a.frame = CGRectMake(0, 0, 30, 18);
        _q_a.center = _header.center;
        UIColor *color = NormalColor;
        _q_a.titleLabel.font = FONT15;
        [_q_a setTitleColor:color forState:UIControlStateNormal];
        [_q_a setTitle:@"问答" forState:UIControlStateNormal];
        _q_a.tag = 201;
        [_q_a addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_q_a];
        
        _all = [UIButton buttonWithType:UIButtonTypeCustom];
        _all.frame = CGRectMake(CGRectGetMinX(_q_a.frame)-70, CGRectGetMinY(_q_a.frame), 30, 18);
        _all.titleLabel.font = FONT15;
        [_all setTitleColor:color forState:UIControlStateNormal];
        [_all setTitle:@"全部" forState:UIControlStateNormal];
        _all.tag = 200;
        [_all addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_all];
        
        _diss = [UIButton buttonWithType:UIButtonTypeCustom];
        _diss.frame = CGRectMake(CGRectGetMaxX(_q_a.frame)+40, CGRectGetMinY(_q_a.frame), 30, 18);
        _diss.titleLabel.font = FONT15;
        [_diss setTitle:@"讨论" forState:UIControlStateNormal];
        [_diss setTitleColor:color forState:UIControlStateNormal];
        _diss.tag = 202;
        [_diss addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_diss];
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, CGRectGetWidth(_header.frame), 1)];
        bottomLine.backgroundColor = BackgroundColor;
        [_header addSubview:bottomLine];
        
        _bottom = [[UILabel alloc] initWithFrame:CGRectMake(_all.center.x-25, CGRectGetMaxY(_q_a.frame)+4, 50, 3)];
        _bottom.backgroundColor = PrimaryColor;
        [_header addSubview:_bottom];
    }
    return _header;
}
- (void)headerClicked:(UIButton *)button {
    NSInteger offSet = (button.tag - 200)*70;
    [UIView animateWithDuration:0.3 animations:^{
        _bottom.frame = CGRectMake(_all.center.x-25+offSet, CGRectGetMaxY(_q_a.frame)+4, 50, 3);
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWITH*(button.tag-200), _scrollView.frame.origin.y, SCREENWITH, _scrollView.frame.size.width) animated:YES];
    } completion:^(BOOL finished) {
        
    } ];
}
#pragma ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger offSet = scrollView.contentOffset.x/SCREENWITH*70;
    [UIView animateWithDuration:0.3 animations:^{
        _bottom.frame = CGRectMake(_all.center.x-25+offSet, CGRectGetMaxY(_q_a.frame)+4, 50, 3);
    } completion:^(BOOL finished) {
        
    } ];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSet = scrollView.contentOffset.x;
    CGFloat percent = offSet/SCREENWITH;
    UIButton *button = nil;
    if (percent>0.5 && percent<=1.5) {
        button = _q_a;
        percent-=1;
    }else if (percent<=0.5) {
        button = _all;
    }else if (percent>1.5 && percent<=2.5){
        button = _diss;
        percent-=2;
    }
    _bottom.frame = CGRectMake(button.center.x-25+70*percent, CGRectGetMaxY(_q_a.frame)+4, 50, 3);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
