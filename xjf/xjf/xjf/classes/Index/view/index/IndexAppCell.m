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

@interface IndexAppCell () <UzysGridViewDelegate, UzysGridViewDataSource>
@property (nonatomic, strong) UzysGridView *gridView;
@property (nonatomic, strong) NSArray *dataTitle;
@property (nonatomic, strong) NSArray *dataImage;
@end

@implementation IndexAppCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.dataTitle || !self.dataImage) {
            self.dataTitle = @[@"析金百科", @"析金学堂", @"析金从业", @"金融资讯"];
            self.dataImage = @[@"home_wiki", @"home_lesson", @"home_traning", @"home_news"];
        }
        self.backgroundColor = [UIColor whiteColor];
        _gridView = [[UzysGridView alloc] initWithFrame:self.bounds numOfRow:1 numOfColumns:4 cellMargin:0];
        _gridView.backgroundColor = [UIColor whiteColor];
        _gridView.scrollView.backgroundColor = [UIColor whiteColor];

        _gridView.delegate = self;
        _gridView.dataSource = self;
        [self addSubview:_gridView];
    }
    return self;
}

- (void)dealloc {
    self.actionBlock = nil;
    self.data = nil;
    self.key = nil;
    self.other = nil;
    self.indexPath = nil;

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.key = key;
    self.data = model;
    self.indexPath = indexPath;
    NSDictionary *dict = (NSDictionary *) model;
    [_gridView reloadData];

}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    NSDictionary *dict = (NSDictionary *) model;
    return 95;

}

- (NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview {
    return 4;
}

- (UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    AppGridViewCell *cell = [[AppGridViewCell alloc] initWithFrame:CGRectNull];
    cell.deletable = NO;
    cell.titleLable.text = self.dataTitle[index];
    cell.imageTag.image = [UIImage imageNamed:self.dataImage[index]];
    return cell;
}

- (void)gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index {
    if (self.actionBlock) {
        self.actionBlock(BEventType_Unknow, nil, self.dataTitle, [NSString stringWithFormat:@"%ld", index], self.indexPath);
    }
}


@end
