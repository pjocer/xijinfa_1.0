//
//  VideoListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VideoListCell.h"

@interface VideoListCell ()
///视频图片
@property (nonatomic, strong) UIImageView *videoImage;
///视频标题
@property (nonatomic, strong) UILabel *videoTitle;
@property (nonatomic, strong) UILabel *vipLogo;
@end

@implementation VideoListCell
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
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        
        //videoImage
        self.videoImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.videoImage];
        self.videoImage.backgroundColor = BackgroundColor;
        [self.videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView).with.offset(10);
            make.width.mas_equalTo((SCREENWITH / 2) - 20);
            make.height.equalTo(self.videoImage.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);

        }];
        
        //videoTitle
        self.videoTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.videoTitle];
        self.videoTitle.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.videoTitle.font = FONT15;
        self.videoTitle.numberOfLines = 2;
        [self.videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoImage.mas_right).with.offset(10);
            make.right.mas_equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.videoImage);
            make.height.mas_equalTo(15);
        }];
        
        
        //viedoDetail
        self.viedoDetail = [[UILabel alloc] init];
        [self addSubview:self.viedoDetail];
        self.viedoDetail.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.viedoDetail.font = FONT12;
        [self.viedoDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoTitle);
            make.top.equalTo(self.videoTitle.mas_bottom);
            make.right.mas_equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(15);
        }];
        self.viedoDetail.hidden = YES;
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self.contentView addSubview:self.teacherName];
        self.teacherName.textColor = AssistColor
        self.teacherName.font = FONT12;
        self.teacherName.hidden = YES;
        [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.viedoDetail.mas_bottom).with.offset(7);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(14);
        }];
        
        //lessonCount
        self.lessonCount = [[UILabel alloc] init];
        [self.contentView addSubview:self.lessonCount];
        self.lessonCount.textColor = AssistColor
        self.lessonCount.font = FONT12;
        self.lessonCount.hidden = YES;
        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.teacherName.mas_bottom).with.offset(3);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(14);
        }];
        

        
        //price
        self.price = [[UILabel alloc] init];
        [self.contentView addSubview:self.price];
        self.price.textColor = [UIColor redColor];
        self.price.font = FONT15;
        self.price.hidden = YES;
        self.price.textAlignment = NSTextAlignmentLeft;
        [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.bottom.mas_equalTo(self.videoImage);
            make.width.mas_equalTo(72);
            make.height.mas_equalTo(14);
        }];
        
        //oldPrice
        self.oldPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.oldPrice];
        self.oldPrice.textColor = AssistColor
        self.oldPrice.font = FONT12;
        self.oldPrice.hidden = YES;
        self.oldPrice.textAlignment = NSTextAlignmentLeft;
        [self.oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.price.mas_right);
            make.bottom.equalTo(self.price);
            make.size.mas_equalTo(CGSizeMake(45, 14));
        }];
        
        //selectedLabel;
        self.selectedLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.selectedLabel];
        [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        self.selectedLabel.layer.borderWidth = 1;
        self.selectedLabel.layer.masksToBounds = YES;
        self.selectedLabel.layer.cornerRadius = 7;
        self.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        self.selectedLabel.hidden = YES;
        
        //vipLogo
        self.vipLogo = [[UILabel alloc] init];
        [self.contentView addSubview:self.vipLogo];
        [self.vipLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.videoImage);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        self.vipLogo.backgroundColor = [UIColor redColor];
        self.vipLogo.textAlignment = NSTextAlignmentCenter;
        self.vipLogo.textColor = [UIColor whiteColor];
        self.vipLogo.font = FONT12;
        self.vipLogo.text = @"Vip 专享";
        self.vipLogo.hidden = YES;
    }
    return self;
}

- (void)setModel:(TalkGridModel *)model
{
    if (model) {
        _model = model;
    }
    
    
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.videoTitle.text = model.title;
    self.viedoDetail.text = model.content;
    self.lessonCount.text = [NSString stringWithFormat:@"课时: %@",model.lessons_count];
    if (model.taxonomy_gurus.count != 0 && model.taxonomy_gurus) {
        taxonomy_gurus *gurus = model.taxonomy_gurus.firstObject;
        self.teacherName.text = [NSString stringWithFormat:@"主讲: %@",gurus.title];
    }
    CGFloat tempPrice = [model.price floatValue];
    if (tempPrice == -1) {
         self.price.text = @"";
    }else {
        self.price.text = [NSString stringWithFormat:@"￥%.2lf",tempPrice / 100];
    }
    if (model.origin != nil && model.origin.length > 0) {
        CGFloat oldPrice = [model.origin floatValue];
        self.oldPrice.text = [NSString stringWithFormat:@"￥%.2lf",oldPrice / 100];
    }
   
}

- (void)setVipModel:(VipModel *)vipModel
{
    if (vipModel) {
        _vipModel = vipModel;
    }

    if ([vipModel.period isEqualToString:@"1m"]) {
       //月付
        self.videoImage.image = [UIImage imageNamed:@"icon_vip_1m"];
         CGFloat price = [vipModel.price floatValue] / 100;
        self.videoTitle.text = [NSString stringWithFormat:@"月费会员充值%.2lf元 ￥%.2lf/月",price,price];
    } else if ([vipModel.period isEqualToString:@"1y"]) {
       //年付
        self.videoImage.image = [UIImage imageNamed:@"icon_vip_12m"];
        CGFloat price = [vipModel.price floatValue] / 100 / 12;
        self.videoTitle.text = [NSString stringWithFormat:@"年费会员充值%.2lf元 ￥%.2lf/月",[vipModel.price floatValue] / 100,price];
    }
    self.price.text = [NSString stringWithFormat:@"￥%.2lf",[vipModel.price floatValue] / 100];
    
    if (self.vipModel && self.vipModel != nil) {
        [self.videoTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoImage.mas_right).with.offset(10);
            make.right.mas_equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.videoImage);
            make.height.mas_equalTo(37);
        }];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_isMyOrder) {
        if (self.model.user_purchased || self.model.user_subscribed) {
            self.price.hidden = YES;
            self.oldPrice.hidden = YES;
        }else{
            self.price.hidden = NO;
        }
    }else {
        //    "status": 0, // 订单状态 1待支付，2取消订单，4订单冲突（已支付） 9支付成功
         if (self.status == 1) {
            self.price.hidden = NO;
         }else {
             self.price.hidden = YES;
             self.oldPrice.hidden = YES;
         }

    }

    
    if ([self.price.text isEqualToString:@""]) {
        self.oldPrice.hidden = YES;
    }
    
    if (self.selectedLabel.hidden == NO) {
        
        CGFloat videoImageH;
        if (iPhone4 || iPhone5) {
            videoImageH = 130.0;
        }
        else{
            videoImageH = 155.0;
        }
        //videoImage
        [self.videoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.selectedLabel.mas_right).with.offset(20);
            make.width.mas_equalTo(videoImageH);
            make.height.mas_equalTo(videoImageH * 0.56);
        }];
    }
    

    if (self.viedoDetail.hidden) {
        //teacherName
        [self.teacherName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.videoTitle.mas_bottom).with.offset(7);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(15);
        }];
        
        //lessonCount
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.teacherName.mas_bottom).with.offset(3);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(15);
        }];
    }
    
    if (self.teacherName.text.length == 0 || self.teacherName.text == nil) {
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.videoTitle.mas_bottom).with.offset(7);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(14);
        }];
    }
    
    if (self.model.package.count != 0 && [self.model.package containsObject:@"subscriber"]) {
        self.vipLogo.hidden = NO;
    }else {
        self.vipLogo.hidden = YES;
    }
}


@end
