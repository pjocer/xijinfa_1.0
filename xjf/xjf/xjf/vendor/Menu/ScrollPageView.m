//
//  ScrollPageView.m
//  xjf
//
//  Created by yiban on 16/4/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "ScrollPageView.h"
#import "HomeViewCell.h"
@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSLog(@"ScrollViewFrame:(%f,%f)",self.frame.size.width,self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

-(void)dealloc{
    [_contentItems removeAllObjects],_contentItems= nil;
    _scrollView=nil;
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables{
    for (int i = 0; i < aNumerOfTables; i++) {
        CustomTableView *vCustomTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.frame.size.height)];
        vCustomTableView.delegate = self;
        vCustomTableView.dataSource = self;
        [_scrollView addSubview:vCustomTableView];
        [_contentItems addObject:vCustomTableView];
    }
    [_scrollView setContentSize:CGSizeMake(320 * aNumerOfTables, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
    CustomTableView *vTableContentView =(CustomTableView *)[_contentItems objectAtIndex:aIndex];
    [vTableContentView forceToFreshData];
}
#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent{
 
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+320/2.0) / 320;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        //        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        //        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        //        [self moveToTargetPosition:targetX];
    }
    
    
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"homeCell";
    HomeViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil] lastObject];
    }
    
    NSInteger vNewIndex = aIndexPath.row % 4 + 1;
    vCell.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new%d",vNewIndex]];
    return vCell;
}

#pragma mark CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    HomeViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    //    double delayInSeconds = 1.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    for (int i = 0; i < 4; i++) {
        [aView.tableInfoArray  addObject:@"0"];
    }
    if (complete) {
        complete(4);
    }
    //    });
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [aView.tableInfoArray removeAllObjects];
        for (int i = 0; i < 4; i++) {
            [aView.tableInfoArray addObject:@"0"];
        }
        //改变header显示图片
        [self changeHeaderContentWithCustomTable:aView];
        if (complete) {
            complete();
        }
    });
}

@end