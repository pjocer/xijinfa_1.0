//
//  IndexTalkCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexTalkCell.h"
#import "IndexSectionView.h"
#import "UzysGridView.h"
#import "TalkGridViewCell.h"

@interface IndexTalkCell()<UzysGridViewDelegate,UzysGridViewDataSource>
{
    
}
@property(nonatomic,strong)IndexSectionView *sectionView;
@property(nonatomic,strong)UzysGridView *gridView;
@end
@implementation IndexTalkCell
@synthesize sectionView=_sectionView;
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
        //
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        _sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _sectionView.titleLabel.text=@" 金融百科";
        _sectionView.userInteractionEnabled =YES;
        [_sectionView addGestureRecognizer:singleRecognizer];
        singleRecognizer=nil;
        [self addSubview:_sectionView];
        
        //
        _gridView = [[UzysGridView alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height-35) numOfRow:2 numOfColumns:2 cellMargin:2];
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
    return 350;
    
}
-(NSInteger) numberOfCellsInGridView:(UzysGridView *)gridview {
    return 4;
}
-(UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index
{
    TalkGridViewCell *cell = [[TalkGridViewCell alloc] initWithFrame:CGRectNull];
    cell.deletable = NO;
    return cell;
}
-(void)handleSingleTapFrom
{
    if (self.actionBlock) {
        self.actionBlock(BEventType_More,nil,self.data,nil,self.indexPath);
    }
}
@end
