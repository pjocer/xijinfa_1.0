//
//  SelectedTableView.m
//  xjf
//
//  Created by Hunter_wang on 16/7/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedTableView.h"
#import "UIGestureRecognizer+Block.h"

@interface SelectedTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SelectedTableView
static CGFloat SelectedTableViewRowH = 50;
static NSString *SelectedTableViewCell_ID = @"SelectedTableViewCell_ID";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backGroudView];
        [self addSubview:self.tableView];
        
        [self makeSubViewsConstraints];
    
        @weakify(self)
        [RACObserve(self, frame) subscribeNext:^(id x) {
            @strongify(self)
            CGRect rect = [x CGRectValue];
            self.tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height / 2);
            self.backGroudView.frame = rect;
        }];
    }
    return self;
}


- (void)makeSubViewsConstraints
{
    _backGroudView.frame = self.frame;
    
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2);
}

#pragma mark - setter

- (void)setDataSource:(NSMutableArray<NSString *> *)dataSource
{
    if (dataSource) {
        _dataSource = dataSource;
    }
    [_tableView reloadData];
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]
                          initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.rowHeight = SelectedTableViewRowH;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SelectedTableViewCell_ID];
    }
    return _tableView;
}

- (UIView *)backGroudView
{
    if (!_backGroudView) {
        self.backGroudView = [[UIView alloc] init];
        _backGroudView.backgroundColor = [UIColor blackColor];
        _backGroudView.alpha = 0.35;
        __unsafe_unretained __typeof(self) weakSelf = self;
        [_backGroudView addGestureRecognizer:[UITapGestureRecognizer ht_gestureRecognizerWithActionBlock:^(id gestureRecognizer) {
            weakSelf.selectedTableViewFrameUnShow();
        }]];
    }
    return _backGroudView;
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SelectedTableViewCell_ID];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark  didSelectRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedTableView:didSelectRowAtIndexPath:DataSource:)]) {
        [_delegate selectedTableView:self didSelectRowAtIndexPath:indexPath DataSource:_dataSource];
    }
}

@end
