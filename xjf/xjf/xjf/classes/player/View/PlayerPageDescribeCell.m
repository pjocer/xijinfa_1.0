//
//  PlayerPageDescribeCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeCell.h"

@implementation PlayerPageDescribeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.videoDescribe = [[UILabel alloc] init];
        [self addSubview:self.videoDescribe];
        self.videoDescribe.font = FONT12;
        self.videoDescribe.textColor = AssistColor;

        CGRect tempRect = [StringUtil calculateLabelRect:self.model.content width:SCREENWITH - 20 fontsize:12];
        self.videoDescribe.frame = CGRectMake(10, 10, self.bounds.size.width - 20, tempRect.size.height);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tempRect = [StringUtil calculateLabelRect:self.model.content width:SCREENWITH - 20 fontsize:12];
    self.videoDescribe.frame = CGRectMake(10, 10, self.bounds.size.width - 20, tempRect.size.height);

}

- (void)setModel:(TalkGridModel *)model {
    if (model) {
        _model = model;
    }
    self.videoDescribe.text = model.content;

}


@end
