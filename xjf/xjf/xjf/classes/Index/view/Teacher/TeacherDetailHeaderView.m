//
//  TeacherDetailHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherDetailHeaderView.h"

@interface TeacherDetailHeaderView ()
///老师头像
@property(nonatomic, strong) UIImageView *teacherImage;
///老师名字
@property(nonatomic, strong) UILabel *teacherName;
///老师详情
@property(nonatomic, strong) UILabel *teacherDetail;
@property(nonatomic, strong) UIView *bottomView;
@end


@implementation TeacherDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat teacherImageH = 55;
        CGFloat userNameW = 60;
        CGFloat FocusButtonW = 90;
        CGFloat FocusButtonH = 33;
        //teacherImage
        self.teacherImage = [[UIImageView alloc] init];
        self.teacherImage.backgroundColor = BackgroundColor
        self.teacherImage.layer.masksToBounds = YES;
        self.teacherImage.layer.cornerRadius = teacherImageH / 2;
        [self addSubview:self.teacherImage];
        [self.teacherImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
            make.size.mas_offset(CGSizeMake(teacherImageH, teacherImageH));
        }];
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self addSubview:self.teacherName];
        self.teacherName.font = FONT15;
        self.teacherName.text = @"析金小白";
        [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.teacherImage);
            make.left.equalTo(self.teacherImage.mas_right).with.offset(10);
            make.height.mas_equalTo(self.teacherImage).multipliedBy(0.5);
            make.width.mas_equalTo(userNameW);
        }];
        
        //FocusButton
        self.focusButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.focusButton];
        self.focusButton.backgroundColor = BlueColor;
        self.focusButton.tintColor = [UIColor whiteColor];
        self.focusButton.titleLabel.font = FONT15;
        self.focusButton.layer.masksToBounds = YES;
        self.focusButton.layer.cornerRadius = 4;
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(FocusButtonW, FocusButtonH));
        }];

        //teacherDetail
        self.teacherDetail = [[UILabel alloc] init];
        [self addSubview:self.teacherDetail];
        self.teacherDetail.font = FONT12;
        self.teacherDetail.textColor = AssistColor;
        self.teacherDetail.text = @"超级大师xxxxxxxxxxxxxxx";
        self.teacherDetail.textAlignment = NSTextAlignmentLeft;
        self.teacherDetail.numberOfLines = 2;
        [self.teacherDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.teacherName.mas_bottom);
            make.left.equalTo(self.teacherName);
            make.height.equalTo(self.teacherName).multipliedBy(1.3);
            make.right.equalTo(self.focusButton.mas_left).with.offset(-10);
        }];
        
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = BackgroundColor;
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setModel:(TeacherListData *)model
{
    if (model) {
        _model = model;
    }
    [self.teacherImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.teacherName.text = model.title;
    self.teacherDetail.text = model.summary;
    
//    if (model.user_favored) {
//        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
//        self.focusButton.backgroundColor = BackgroundColor;
//        self.focusButton.tintColor = AssistColor;
//    }else {
//        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
//        self.focusButton.backgroundColor = BlueColor;
//        self.focusButton.tintColor = [UIColor whiteColor];
//    }
}

@end
