//
//  LessonDetailLessonListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailLessonListCell.h"

@interface LessonDetailLessonListCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *lessonCount;
@end

@implementation LessonDetailLessonListCell
static CGFloat StudyImageH = 20;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        self.title.text = @"股票基础课程 第x课";

        self.studyImage = [[UIImageView alloc] init];
        [self addSubview:self.studyImage];
        self.studyImage.layer.masksToBounds = YES;
        self.studyImage.layer.cornerRadius = StudyImageH / 2;
        self.studyImage.backgroundColor = BlueColor;
        [self.studyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];

        self.lessonCount = [[UILabel alloc] init];
        [self addSubview:self.lessonCount];
        self.lessonCount.font = FONT12;
        self.lessonCount.textAlignment = NSTextAlignmentLeft;
        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.studyImage.mas_left).with.offset(-30);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(45);
        }];
        self.lessonCount.text = @"00:00";
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.studyImage.hidden) {
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(45);
        }];
    }
}


- (void)setModel:(LessonDetailListLessonsModel *)model {
    if (model) {
        _model = model;
    }

    self.title.text = model.title;

}


@end
