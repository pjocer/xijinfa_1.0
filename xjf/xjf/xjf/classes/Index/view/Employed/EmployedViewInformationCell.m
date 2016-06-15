//
//  EmployedViewInformationCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedViewInformationCell.h"

@interface EmployedViewInformationCell ()
///分割线
@property (nonatomic, strong) UIView *customSeparator;
///资讯图片
@property (nonatomic, strong) UIImageView *videoImage;
///资讯标题
@property (nonatomic, strong) UILabel *videoTitle;
///资讯详情
@property (nonatomic, strong) UILabel *viedoDetail;
@end

@implementation EmployedViewInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
        self.videoTitle.font = FONT15;
        self.videoTitle.numberOfLines = 2;
        [self.videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoImage.mas_right).with.offset(10);
            make.right.mas_equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.videoImage);
            make.height.mas_equalTo(self.videoImage).multipliedBy(0.5);
        }];
        
        //viedoDetail
        self.viedoDetail = [[UILabel alloc] init];
        [self addSubview:self.viedoDetail];
        self.viedoDetail.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.viedoDetail.font = FONT12;
        self.viedoDetail.numberOfLines = 2;
        [self.viedoDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoTitle);
            make.top.equalTo(self.videoTitle.mas_bottom);
            make.right.mas_equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(self.videoImage).multipliedBy(0.5);
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
@end
