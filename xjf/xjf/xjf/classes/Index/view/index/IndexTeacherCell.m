//
//  IndexTeacherCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexTeacherCell.h"
#import "IndexSectionView.h"
#import "UzysGridView.h"
#import "TeacherGridViewCell.h"

@interface IndexTeacherCell () <UzysGridViewDelegate, UzysGridViewDataSource>
@property (nonatomic, strong) TeacherListHostModel *teacherListHostModel;
@property (nonatomic, strong) IndexSectionView *sectionView;
@property (nonatomic, strong) UzysGridView *gridView;
@end

@implementation IndexTeacherCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _sectionView.titleLabel.text = @"析金讲师";
        _sectionView.moreLabel.text = @"";
        _sectionView.userInteractionEnabled = NO;
        [self addSubview:_sectionView];

        //
        _gridView = [[UzysGridView alloc]
                initWithFrame:CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height - 35)
                     numOfRow:1
                 numOfColumns:3
                   cellMargin:1];
        _gridView.delegate = self;
        _gridView.dataSource = self;
        [self addSubview:_gridView];
    }
    return self;
}

/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.key = key;
    self.data = model;
    self.indexPath = indexPath;
    self.teacherListHostModel = (TeacherListHostModel *) model;
    [_gridView reloadData];
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    return 188;
}

- (NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview {
    return [self.teacherListHostModel.result.data count];
}

- (UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    TeacherGridViewCell *cell = [[TeacherGridViewCell alloc] initWithFrame:CGRectNull];
    if (self.teacherListHostModel.result.data && self.teacherListHostModel.result.data.count > index)
        cell.model = self.teacherListHostModel.result.data[index];
    return cell;
}

- (void)handleSingleTapFrom {
    if (self.actionBlock) {
        self.actionBlock(BEventType_More, nil, self.data, nil, self.indexPath);
    }
}

- (void)gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index {
    if (self.actionBlock) {
        self.actionBlock(BEventType_Unknown, nil, self.teacherListHostModel.result.data[index], nil, self.indexPath);
    }
}

@end
