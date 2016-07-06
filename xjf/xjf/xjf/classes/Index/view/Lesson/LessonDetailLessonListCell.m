//
//  LessonDetailLessonListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailLessonListCell.h"

@interface LessonDetailLessonListCell ()
@property (nonatomic, strong) UILabel *lessonCount;
@property (nonatomic, strong) UIView *backGroundView;
@end

@implementation LessonDetailLessonListCell
static CGFloat StudyImageH = 20;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backGroundView = [[UIView alloc] init];
        [self.contentView addSubview:_backGroundView];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        ViewRadius(_backGroundView, 5);

//        iconFavorites
        self.favorites = [[UIImageView alloc] init];
        [_backGroundView addSubview:self.favorites];
//        self.favorites.image = [UIImage imageNamed:@"iconFavoritesOn"];
        [self.favorites mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backGroundView).with.offset(10);
            make.centerY.equalTo(_backGroundView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        self.title = [[UILabel alloc] init];
        [_backGroundView addSubview:self.title];
        self.title.font = FONT15;
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backGroundView).with.offset(34);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(18);
            make.width.equalTo(_backGroundView).multipliedBy(0.5).with.offset(-25);
        }];
        self.title.text = @"股票基础课程 第x课";

        self.freeVideoLogo = [[UILabel alloc] init];
        [_backGroundView addSubview:self.freeVideoLogo];
        self.freeVideoLogo.font = FONT12;
        self.freeVideoLogo.textAlignment = NSTextAlignmentCenter;
        self.freeVideoLogo.backgroundColor = [UIColor redColor];
        self.freeVideoLogo.textColor = [UIColor whiteColor];
        self.freeVideoLogo.text = @"免费试看";
        self.freeVideoLogo.layer.masksToBounds = YES;
        self.freeVideoLogo.layer.cornerRadius = 10;
        [self.freeVideoLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).with.offset(10);
            make.centerY.equalTo(_backGroundView);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        self.freeVideoLogo.hidden = YES;

        self.studyImage = [[UIImageView alloc] init];
        [_backGroundView addSubview:self.studyImage];
        self.studyImage.layer.masksToBounds = YES;
        self.studyImage.layer.cornerRadius = StudyImageH / 2;
        self.studyImage.image = [[UIImage imageNamed:@"learend"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.studyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backGroundView).with.offset(-10);
            make.centerY.equalTo(_backGroundView);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];

        self.lessonCount = [[UILabel alloc] init];
        [_backGroundView addSubview:self.lessonCount];
        self.lessonCount.font = FONT12;
        self.lessonCount.textAlignment = NSTextAlignmentLeft;
        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.studyImage.mas_left).with.offset(-15);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(45);
        }];
        self.lessonCount.textColor = AssistColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.isPay) {
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backGroundView).with.offset(-10);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(60);
        }];
    }
    else {
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.studyImage.mas_left).with.offset(-15);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(60);
        }];
    }

}


- (void)setTalkGridModel:(TalkGridModel *)talkGridModel {
    if (talkGridModel) {
        _talkGridModel = talkGridModel;
    }
    self.title.text = talkGridModel.title;

    self.lessonCount.text = [NSString timeformatFromSeconds:talkGridModel.video_duration];
}


@end
