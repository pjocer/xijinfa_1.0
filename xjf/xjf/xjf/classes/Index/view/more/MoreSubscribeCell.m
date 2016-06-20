//
//  MoreSubscribeCell.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MoreSubscribeCell.h"

#import "IndexSectionView.h"
#import "UzysGridView.h"
#import "TeacherGridViewCell.h"

@interface MoreSubscribeCell () <UzysGridViewDelegate, UzysGridViewDataSource>
@property (nonatomic, strong) IndexSectionView *sectionView;
@property (nonatomic, strong) UzysGridView *gridView;
@end

@implementation MoreSubscribeCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        //
        _sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 30)];
        _sectionView.titleLabel.text = @"｜订阅";
        [self addSubview:_sectionView];

        //
        _gridView = [[UzysGridView alloc] initWithFrame:CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height - 30)
                                               numOfRow:4
                                           numOfColumns:1
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
    [_gridView reloadData];
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    return 200;
}

- (NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview {
    return 4;
}

- (UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    TeacherGridViewCell *cell = [[TeacherGridViewCell alloc] initWithFrame:CGRectNull];
    return cell;
}

@end
