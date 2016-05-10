//
//  IndexAppCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexAppCell.h"
#import "UzysGridView.h"
#import "AppGridViewCell.h"

@interface IndexAppCell()<UzysGridViewDelegate,UzysGridViewDataSource>
{
    
}
@property(nonatomic,strong)UzysGridView *gridView;
@end
@implementation IndexAppCell
@synthesize gridView=_gridView;

-(void)setCallBack:(void(^)(BEventType,UIView*,id,id,NSIndexPath *))callback
{
    self.actionBlock=callback;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        _gridView = [[UzysGridView alloc] initWithFrame:self.bounds numOfRow:2 numOfColumns:2 cellMargin:1];
        _gridView.delegate = self;
        _gridView.dataSource = self;
        [self addSubview:_gridView];
    }
    return self;
}
-(void)dealloc
{
    self.actionBlock =nil;
    self.data=nil;
    self.key =nil;
    self.other=nil;
    self.indexPath=nil;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath
{
    self.key =key;
    self.data =model;
    self.indexPath =indexPath;
    NSDictionary *dict =(NSDictionary*)model;
    [_gridView reloadData];

}
/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model
{
    NSDictionary *dict =(NSDictionary*)model;
    return 200;
    
}
-(NSInteger) numberOfCellsInGridView:(UzysGridView *)gridview {
    return 4;
}
-(UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index
{
    AppGridViewCell *cell = [[AppGridViewCell alloc] initWithFrame:CGRectNull];
    cell.deletable = NO;
    return cell;
}
@end
