//
//  LessonDetailTecherDescribeCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailTecherDescribeCell.h"

@interface LessonDetailTecherDescribeCell ()
///老师头像
@property (nonatomic, strong) UIImageView *teacherImage;
///老师名字
@property (nonatomic, strong) UILabel *teacherName;
///老师详情
@property (nonatomic, strong) UILabel *teacherDetail;
///关注按钮
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIView *bottomView;
@end


@implementation LessonDetailTecherDescribeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat teacherImageH = 55;
        CGFloat userNameW = 60;
        CGFloat FocusButtonW = 90;
        CGFloat FocusButtonH = 33;
        //teacherImage
        self.teacherImage = [[UIImageView alloc] init];
        self.teacherImage.backgroundColor = BackgroundColor
        self.teacherImage.layer.masksToBounds = YES;
        self.teacherImage.layer.cornerRadius = teacherImageH / 2;
        [self.contentView addSubview:self.teacherImage];
        [self.teacherImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(teacherImageH, teacherImageH));
        }];
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self.contentView addSubview:self.teacherName];
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
        [self.contentView addSubview:self.focusButton];
        self.focusButton.backgroundColor = BlueColor;
        self.focusButton.tintColor = [UIColor whiteColor];
        self.focusButton.titleLabel.font = FONT15;
        self.focusButton.layer.masksToBounds = YES;
        self.focusButton.layer.cornerRadius = 4;
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(FocusButtonW, FocusButtonH));
        }];
        
        //teacherDetail
        self.teacherDetail = [[UILabel alloc] init];
        [self.contentView addSubview:self.teacherDetail];
        self.teacherDetail.font = FONT12;
        self.teacherDetail.textColor = AssistColor;
        self.teacherDetail.text = @"超级大师xxxxxxxxxxxxxxx";
        self.teacherDetail.textAlignment = NSTextAlignmentLeft;
        [self.teacherDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.teacherName.mas_bottom);
            make.left.equalTo(self.teacherName);
            make.height.equalTo(self.teacherName);
            make.right.equalTo(self.focusButton.mas_left).with.offset(-10);
        }];

        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = BackgroundColor;
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
@end
