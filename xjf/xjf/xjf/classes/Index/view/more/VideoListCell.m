//
//  VideoListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VideoListCell.h"

@interface VideoListCell ()
///分割线
@property (nonatomic, strong) UIView *customSeparator;
///视频图片
@property (nonatomic, strong) UIImageView *videoImage;
///视频标题
@property (nonatomic, strong) UILabel *videoTitle;
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
            make.bottom.mas_equalTo(self.contentView).with.offset(-1);
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
        self.videoTitle.text = @"XXXXXXX";
        self.videoTitle.font = FONT15;
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
        self.viedoDetail.text = @"xxxxxxxxxxx";
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
        self.teacherName.text = @"主讲: xxxx";
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
        self.lessonCount.text = @"课时: xxxx";
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
        self.price.text = @"￥0000";
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
        self.oldPrice.text = @"￥0000";
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
    CGFloat tempPrice = [model.price floatValue];
    if (tempPrice == -1) {
         self.price.text = @"";
    }else {
        self.price.text = [NSString stringWithFormat:@"￥%.2lf",tempPrice / 100];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.model.user_purchased) {
        self.teacherName.hidden = NO;
        self.lessonCount.hidden = NO;
        self.price.hidden = YES;
        self.oldPrice.hidden = YES;
    }else{
        self.teacherName.hidden = NO;
        self.lessonCount.hidden = NO;
        self.price.hidden = NO;
    }
    
    if ([self.price.text isEqualToString:@"免费"]) {
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
            make.top.mas_equalTo(self.videoTitle.mas_bottom).with.offset(3);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(14);
        }];
        
        //lessonCount
        [self.lessonCount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.top.mas_equalTo(self.teacherName.mas_bottom);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(14);
        }];
    }
    
}


@end
