//
//  LessonDetailHaveToPayHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailHaveToPayHeaderView.h"


@interface LessonDetailHaveToPayHeaderView ()
@property(nonatomic, strong) UIImageView *noStudyImage;
@property(nonatomic, strong) UILabel *noStudyLabel;
@property(nonatomic, strong) UIImageView *studingImage;
@property(nonatomic, strong) UILabel *studingLabel;
@property(nonatomic, strong) UIImageView *studedImage;
@property(nonatomic, strong) UILabel *studedLabel;
///修饰图
@property(nonatomic, strong) UIView *modifiedView;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *lessonCount;
@property(nonatomic, strong) UILabel *progress;
@end

@implementation LessonDetailHaveToPayHeaderView
static CGFloat StudyImageH = 20;
static CGFloat StudyLabelW = 40;
static CGFloat StudyLabelH = 14;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.noStudyImage = [[UIImageView alloc] init];
        [self addSubview:self.noStudyImage];
        self.noStudyImage.layer.masksToBounds = YES;
        self.noStudyImage.layer.cornerRadius = StudyImageH / 2;
        self.noStudyImage.image = [UIImage imageNamed:@"study"];
        [self.noStudyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];

        self.noStudyLabel = [[UILabel alloc] init];
        [self addSubview:self.noStudyLabel];
        self.noStudyLabel.font = FONT12;
        self.noStudyLabel.textColor = AssistColor;
        self.noStudyLabel.text = @"未学习";
        [self.noStudyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noStudyImage.mas_right).with.offset(10);
            make.centerY.equalTo(self.noStudyImage);
            make.size.mas_equalTo(CGSizeMake(StudyLabelW, StudyLabelH));
        }];

        self.studingImage = [[UIImageView alloc] init];
        [self addSubview:self.studingImage];
        self.studingImage.layer.masksToBounds = YES;
        self.studingImage.layer.cornerRadius = StudyImageH / 2;
        self.studingImage.image = [UIImage imageNamed:@"studing"];
        [self.studingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX).with.offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];

        self.studingLabel = [[UILabel alloc] init];
        [self addSubview:self.studingLabel];
        self.studingLabel.font = FONT12;
        self.studingLabel.textColor = AssistColor;
        self.studingLabel.text = @"学习中";
        [self.studingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.noStudyImage);
            make.size.mas_equalTo(CGSizeMake(StudyLabelW, StudyLabelH));
        }];

        self.studedLabel = [[UILabel alloc] init];
        [self addSubview:self.studedLabel];
        self.studedLabel.font = FONT12;
        self.studedLabel.textColor = AssistColor;
        self.studedLabel.text = @"已学习";
        [self.studedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self.noStudyImage);
            make.size.mas_equalTo(CGSizeMake(StudyLabelW, StudyLabelH));
        }];

        self.studedImage = [[UIImageView alloc] init];
        [self addSubview:self.studedImage];
        self.studedImage.layer.masksToBounds = YES;
        self.studedImage.layer.cornerRadius = StudyImageH / 2;
        self.studedImage.image = [UIImage imageNamed:@"studyed"];
        [self.studedImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.studedLabel.mas_left).with.offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];


        //modifiedView
        self.modifiedView = [[UIView alloc] init];
        self.modifiedView.backgroundColor = BackgroundColor;
        [self addSubview:self.modifiedView];
        [self.modifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self);
        }];
//        //////////////////////////////////////////
//        self.title = [[UILabel alloc] init];
//        [self addSubview:self.title];
//        self.title.font = FONT15;
//        self.title.textAlignment = NSTextAlignmentLeft;
//        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).with.offset(10);
//            make.centerY.equalTo(self).multipliedBy(1.5);
//            make.height.mas_equalTo(18);
//            make.width.equalTo(self).multipliedBy(0.5);
//        }];
//        self.title.text = @"股票基础课程";

//        self.progress = [[UILabel alloc] init];
//        [self addSubview:self.progress];
//        self.progress.font = FONT12;
//        self.progress.textColor = AssistColor;
//        self.progress.textAlignment = NSTextAlignmentLeft;
//        [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).with.offset(-10);
//            make.centerY.equalTo(self).multipliedBy(1.5);
//            make.height.mas_equalTo(14);
//            make.width.mas_equalTo(24);
//        }];
//        self.progress.text = @"进度";
//
//        self.lessonCount = [[UILabel alloc] init];
//        [self addSubview:self.lessonCount];
//        self.lessonCount.font = FONT12;
//        self.lessonCount.textColor = AssistColor;
//        self.lessonCount.textAlignment = NSTextAlignmentCenter;
//        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.progress.mas_left).with.offset(-30);
//            make.centerY.equalTo(self).multipliedBy(1.5);
//            make.height.mas_equalTo(14);
//            make.width.mas_equalTo(45);
//        }];
//        self.lessonCount.text = @"课时";


    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
