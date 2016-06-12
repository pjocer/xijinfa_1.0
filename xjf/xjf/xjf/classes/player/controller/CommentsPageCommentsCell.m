//
//  CommentsPageCommentsCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentsPageCommentsCell.h"

@interface CommentsPageCommentsCell ()
///分割线
@property (nonatomic, strong) UIView *customSeparator;
///用户头像
@property (nonatomic, strong) UIImageView *userImage;
///用户名字
@property (nonatomic, strong) UILabel *userName;
///评论时间
@property (nonatomic, strong) UILabel *commentsTime;
///用户详情
@property (nonatomic, strong) UILabel *userDetail;
///评论内容
@property (nonatomic, strong) UILabel *commentsText;

@property (nonatomic, assign) CGRect tempRect;
@end

@implementation CommentsPageCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //separator
        self.customSeparator = [[UIView alloc] init];
        self.customSeparator.backgroundColor = BackgroundColor;
        [self.contentView addSubview:self.customSeparator];
        [self.customSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).with.offset(-1);
            make.height.mas_equalTo(1);
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        //userImage
        self.userImage = [[UIImageView alloc] init];
        self.userImage.backgroundColor = BackgroundColor;
        self.userImage.layer.masksToBounds = YES;
        self.userImage.layer.cornerRadius = 20;
        [self.contentView addSubview:self.userImage];
        [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).with.offset(10);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        //userName
        self.userName = [[UILabel alloc] init];
        [self.contentView addSubview:self.userName];
        self.userName.font = FONT15;
        self.userName.text = @"析金小白";
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImage);
            make.left.equalTo(self.userImage.mas_right).with.offset(10);
            make.height.mas_equalTo(self.userImage).multipliedBy(0.5);
            make.width.mas_equalTo(60);
        }];
        
        //commentsTime
        self.commentsTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.commentsTime];
        self.commentsTime.font = FONT12;
        self.commentsTime.textColor = AssistColor;
        self.commentsTime.text = @"  03-30 11:25";
        self.commentsText.textAlignment = NSTextAlignmentLeft;
        [self.commentsTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userName);
            make.left.equalTo(self.userName.mas_right);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(200);
        }];
        
        //userDetail
        self.userDetail = [[UILabel alloc] init];
        [self.contentView addSubview:self.userDetail];
        self.userDetail.font = FONT12;
        self.userDetail.textColor = AssistColor;
        self.userDetail.text = @"海绵宝宝最好的朋友";
        self.userDetail.textAlignment = NSTextAlignmentLeft;
        [self.userDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userName.mas_bottom);
            make.left.equalTo(self.userName);
            make.height.equalTo(self.userName);
            make.width.mas_equalTo(200);
        }];
        
        //commentsText
        self.commentsText = [[UILabel alloc] init];
        [self.contentView addSubview:self.commentsText];
        self.commentsText.font = FONT15;
        self.commentsText.numberOfLines = 0;
//        [self.commentsText mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.userImage.mas_bottom);
//            make.left.equalTo(self.userName);
//            make.right.equalTo(self).with.offset(-10);
//            make.bottom.equalTo(self);
//        }];
    }
    return self;
}

- (void)setCommentsModel:(CommentsModel *)commentsModel
{
    
    if (commentsModel) {
        _commentsModel = commentsModel;
    }
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:commentsModel.user_avatar]];
    self.userName.text = commentsModel.user_nickname;
    self.commentsText.text = commentsModel.content;
    
    self.tempRect = [StringUtil calculateLabelRect:commentsModel.content width:SCREENWITH - 70 fontsize:15];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    self.commentsText.frame = CGRectMake(self.userDetail.frame.origin.x, CGRectGetMaxY(self.userDetail.frame), SCREENWITH - 70, 30);
    [self.commentsText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImage.mas_bottom);
        make.left.equalTo(self.userName);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(self.tempRect.size.height);
    }];
}


@end
