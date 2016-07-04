//
//  SelectedCollectionViewFooter.m
//  xjf
//
//  Created by Hunter_wang on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedCollectionViewFooter.h"

@implementation SelectedCollectionViewFooter


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.removeSelected];
        [self addSubview:self.determine];
    }
    return self;
}

- (UIButton *)removeSelected
{
    if (!_removeSelected) {
        self.removeSelected = [UIButton buttonWithType:UIButtonTypeSystem];
        _removeSelected.frame = CGRectMake(0, 0, self.frame.size.width * 0.7, self.frame.size.height);
        _removeSelected.titleLabel.font = FONT15;
        _removeSelected.backgroundColor = [UIColor whiteColor];
        _removeSelected.tintColor = AssistColor;
        _removeSelected.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _removeSelected.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [_removeSelected setTitle:@"清除筛选" forState:UIControlStateNormal];
    }
    return _removeSelected;
}

- (UIButton *)determine
{
    if (!_determine) {
        self.determine = [UIButton buttonWithType:UIButtonTypeSystem];
        _determine.frame = CGRectMake(CGRectGetMaxX(_removeSelected.frame), 0, self.frame.size.width * 0.3, self.frame.size.height);
        _determine.titleLabel.font = FONT15;
        _determine.tintColor = [UIColor whiteColor];
        _determine.backgroundColor = BlueColor;
        [_determine setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _determine;
}


@end
