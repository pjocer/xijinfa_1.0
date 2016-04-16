//
//  CustomTableView.m
//  xjf
//
//  Created by yiban on 16/4/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_homeTableView == nil) {
            _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == Nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
    }
    return self;
}

-(void)dealloc{
    [_tableInfoArray removeAllObjects], _tableInfoArray = Nil;
    _homeTableView=nil;
  
}

#pragma mark 其他辅助功能
#pragma mark 强制列表刷新
-(void)forceToFreshData{
    [_homeTableView setContentOffset:CGPointMake(_homeTableView.contentOffset.x,  - 66) animated:YES];
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [_refreshHeaderView forceToRefresh:_homeTableView];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
        NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCount = vRows;
        return vRows + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(heightForRowAthIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        return vCell;
    }

    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == mRowCount) {
        if ([_delegate respondsToSelector:@selector(loadData:FromView:)]) {
            [_delegate loadData:^(int aAddedRowCount) {
                NSInteger vNewRowCount = aAddedRowCount;
                if (vNewRowCount > 0) {
                    NSMutableArray *indexPaths = [NSMutableArray array];
                    for (int lIndex = mRowCount; lIndex < mRowCount + vNewRowCount; lIndex++) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:lIndex inSection:0]];
                    }
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                }
            }FromView:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(didSelectedRowAthIndexPath:IndexPath: FromView:)]) {
            [_delegate didSelectedRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        }
    }
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
        [_delegate refreshData:^{
            [self doneLoadingTableViewData];
        } FromView:self];
    }else{
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [self.homeTableView reloadData];
}



@end
