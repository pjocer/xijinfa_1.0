//
//  LessonDetailTitleView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailTitleView.h"


@interface LessonDetailTitleView ()
///视频图片
@property (nonatomic, strong) UIImageView *videoImage;
///视频标题
@property (nonatomic, strong) UILabel *videoTitle;
///视频详情
@property (nonatomic, strong) UILabel *viedoDetail;
///主讲老师
@property (nonatomic, strong) UILabel *teacherName;
///课时
@property (nonatomic, strong) UILabel *lessonCount;
///现在价格
@property (nonatomic, strong) UILabel *price;
///之前前个
@property (nonatomic, strong) UILabel *oldPrice;
@end


@implementation LessonDetailTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //videoImage
        self.videoImage = [[UIImageView alloc] init];
        [self addSubview:self.videoImage];
        self.videoImage.backgroundColor = BackgroundColor;
        [self.videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).with.offset(10);
            make.width.mas_equalTo((SCREENWITH / 2) - 20);
            make.height.equalTo(self.videoImage.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
            
        }];
        
        //videoTitle
        self.videoTitle = [[UILabel alloc] init];
        [self addSubview:self.videoTitle];
        self.videoTitle.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.videoTitle.text = @"XXXXXXX";
        self.videoTitle.font = FONT15;
        [self.videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoImage.mas_right).with.offset(10);
            make.right.mas_equalTo(self).with.offset(-20);
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
            make.right.mas_equalTo(self).with.offset(-20);
            make.height.mas_equalTo(15);
        }];
        
        //lessonCount
        self.lessonCount = [[UILabel alloc] init];
        [self addSubview:self.lessonCount];
        self.lessonCount.textColor = AssistColor
        self.lessonCount.text = @"课时: xxxx";
        self.lessonCount.font = FONT12;
        [self.lessonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.bottom.mas_equalTo(self.videoImage);
            make.right.equalTo(self).with.offset(-100);
            make.height.mas_equalTo(14);
        }];
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self addSubview:self.teacherName];
        self.teacherName.textColor = AssistColor
        self.teacherName.text = @"主讲: xxxx";
        self.teacherName.font = FONT12;
        [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.videoTitle);
            make.bottom.mas_equalTo(self.lessonCount.mas_top).with.offset(-3);
            make.right.equalTo(self).with.offset(-100);
            make.height.mas_equalTo(14);
        }];
        
        //price
        self.price = [[UILabel alloc] init];
        [self addSubview:self.price];
        self.price.textColor = [UIColor redColor];
        self.price.text = @"￥000";
        self.price.font = FONT15;
        self.price.textAlignment = NSTextAlignmentLeft;
        [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lessonCount);
            make.right.equalTo(self).with.offset(-45);
            make.size.mas_equalTo(CGSizeMake(45, 18));
        }];
        
        //oldPrice
        self.oldPrice = [[UILabel alloc] init];
        [self addSubview:self.oldPrice];
        self.oldPrice.textColor = AssistColor
        self.oldPrice.text = @"￥000";
        self.oldPrice.font = FONT12;
        self.oldPrice.textAlignment = NSTextAlignmentLeft;
        [self.oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lessonCount);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(35, 14));
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
    
    if (![[NSString stringWithFormat:@"%@",model.price] isEqualToString:@"免费"]) {
        CGFloat tempPrice = [model.price floatValue];
        self.price.text = [NSString stringWithFormat:@"￥%.2lf",tempPrice / 100];
    }
    
}


@end
