//
//  BaseViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewCell.h"

@implementation BaseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    self.actionBlock = nil;
    self.data = nil;
    self.indexPath = nil;
    self.other = nil;
    self.key = nil;
}

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

/// 根据数据模型来显示内容
- (void)showInfo:(id)model indexPath:(NSIndexPath *)indexPath {
    self.data = model;
    self.indexPath = indexPath;
}

- (void)showInfo:(id)model other:(id)other indexPath:(NSIndexPath *)indexPath {
    self.data = model;
    self.other = other;
    self.indexPath = indexPath;
}

- (void)showInfo:(id)model other:(id)other key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.data = model;
    self.key = key;
    self.other = other;
    self.indexPath = indexPath;
}

/// 根据key模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.data = model;
    self.key = key;
    self.indexPath = indexPath;
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    return 0;
}

@end
