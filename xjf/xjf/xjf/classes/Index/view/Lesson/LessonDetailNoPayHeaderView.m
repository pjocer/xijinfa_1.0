//
//  LessonDetailNoPayHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailNoPayHeaderView.h"

@interface LessonDetailNoPayHeaderView ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *lessonCount;
@end

@implementation LessonDetailNoPayHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc] init];
        [self addSubview:self.title];
        self.title.font = FONT15;
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(18);
            make.width.equalTo(self).multipliedBy(0.5);
        }];
        self.title.text = @"股票基础课程";

        self.lessonCount = [[UILabel alloc] init];
        [self addSubview:self.lessonCount];
        self.lessonCount.font = FONT12;
        self.lessonCount.textColor = AssistColor;
        self.lessonCount.textAlignment = NSTextAlignmentLeft;
        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(45);
        }];
        self.lessonCount.text = @"课时";
    }
    return self;
}

@end
