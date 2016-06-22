//
//  IndexBaikeCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexBaikeCell.h"
#import "IndexSectionView.h"
#import "UzysGridView.h"
#import "BaikeGridViewCell.h"

@interface IndexBaikeCell () <UzysGridViewDelegate, UzysGridViewDataSource>
@property (nonatomic, strong) TablkListModel *talkGridModel;
@property (nonatomic, strong) IndexSectionView *sectionView;
@property (nonatomic, strong) UzysGridView *gridView;
@end

@implementation IndexBaikeCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        UITapGestureRecognizer *singleRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(indexHandleSingleTapFrom)];
        _sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _sectionView.titleLabel.text = @"析金学堂";
        _sectionView.userInteractionEnabled = YES;
        [_sectionView addGestureRecognizer:singleRecognizer];
        singleRecognizer = nil;
        [self addSubview:_sectionView];

        //
        _gridView = [[UzysGridView alloc]
                initWithFrame:CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height - 35)
                     numOfRow:2
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
    self.talkGridModel = (TablkListModel *) model;
    [_gridView reloadData];
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    if (iPhone5 || iPhone4) {
        return 240;
    }
    return 280;
}

- (NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview {
    if (self.talkGridModel.result.data.count > 2) {
        return 2;
    }
    return self.talkGridModel.result.data.count;
}

- (UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    BaikeGridViewCell *cell = [[BaikeGridViewCell alloc] initWithFrame:CGRectNull];
    if (self.talkGridModel.result.data && self.talkGridModel.result.data.count > index) {
        cell.model = self.talkGridModel.result.data[index];
    }
    return cell;
}

- (void)indexHandleSingleTapFrom {
    if (self.actionBlock) {
        self.actionBlock(BEventType_More, nil, self.talkGridModel, nil, self.indexPath);
    }
}

- (void)gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index {
    if (self.actionBlock) {
        self.actionBlock(BEventType_Unknown, nil, self.talkGridModel.result.data[index], nil, self.indexPath);
    }
}

@end
