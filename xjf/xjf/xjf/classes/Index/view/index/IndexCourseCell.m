//
//  IndexCourseCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexCourseCell.h"
#import "IndexSectionView.h"
#import "UzysGridView.h"
#import "CourseGridViewCell.h"

@interface IndexCourseCell()<UzysGridViewDelegate,UzysGridViewDataSource>
@property(nonatomic,strong)IndexSectionView *sectionView;
@property(nonatomic,strong)UzysGridView *gridView;
@end

@implementation IndexCourseCell
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
        _sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _sectionView.titleLabel.text=@" 从业培训";
        _sectionView.moreLabel.text=@"";
        _sectionView.userInteractionEnabled =YES;
        [self addSubview:_sectionView];
        //
        _gridView = [[UzysGridView alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height-35) numOfRow:3 numOfColumns:1 cellMargin:1];
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
    self.sectionView=nil;
    self.gridView=nil;
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
    return 342;
    
}
-(NSInteger) numberOfCellsInGridView:(UzysGridView *)gridview {
    return 3;
}
-(UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index
{
    CourseGridViewCell *cell = [[CourseGridViewCell alloc] initWithFrame:CGRectNull];
    cell.deletable = NO;
    return cell;
}
-(void)handleSingleTapFrom
{
    if (self.actionBlock) {
        self.actionBlock(BEventType_More,nil,self.data,nil,self.indexPath);
    }
}

- (void)gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index
{
    if (self.actionBlock) {
        self.actionBlock(BEventType_More,nil,self.data,nil,self.indexPath);
    }
    
}

@end
