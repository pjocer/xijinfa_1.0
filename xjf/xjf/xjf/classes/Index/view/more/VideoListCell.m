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
///视频详情
@property (nonatomic, strong) UILabel *viedoDetail;

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
            make.right.mas_equalTo(self.contentView).with.offset(-20);
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
            make.right.mas_equalTo(self.contentView).with.offset(-20);
            make.height.mas_equalTo(15);
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
            make.bottom.mas_equalTo(self.videoImage);
            make.right.equalTo(self.contentView).with.offset(-80);
            make.height.mas_equalTo(14);
        }];
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self.contentView addSubview:self.teacherName];
        self.teacherName.textColor = AssistColor
        self.teacherName.text = @"主讲: xxxx";
        self.teacherName.font = FONT12;
        self.teacherName.hidden = YES;
        [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.bottom.mas_equalTo(self.lessonCount.mas_top).with.offset(-3);
            make.right.equalTo(self.contentView).with.offset(-80);
            make.height.mas_equalTo(14);
        }];
        
        //oldPrice
        self.oldPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.oldPrice];
        self.oldPrice.textColor = AssistColor
        self.oldPrice.text = @"$00";
        self.oldPrice.font = FONT12;
        self.oldPrice.hidden = YES;
        [self.oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lessonCount);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 14));
        }];
        
        //price
        self.price = [[UILabel alloc] init];
        [self.contentView addSubview:self.price];
        self.price.textColor = [UIColor redColor];
        self.price.text = @"$000";
        self.price.font = FONT15;
        self.price.hidden = YES;
        [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lessonCount);
            make.right.equalTo(self.oldPrice.mas_left).with.offset(-3);
            make.size.mas_equalTo(CGSizeMake(38, 18));
        }];
        
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
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    //separator
//    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView).with.offset(-1); 
//    }];
//    
//}


@end
