//
//  WikiTalkGridViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiTalkGridViewCell.h"

@interface WikiTalkGridViewCell ()

@property(nonatomic, strong) UIImageView *titleImage;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *detailLable;

@end


@implementation WikiTalkGridViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code

        self.contentView.backgroundColor = [UIColor whiteColor];
        //titleImage
        self.titleImage = [[UIImageView alloc] init];
        [self addSubview:self.titleImage];
        self.titleImage.backgroundColor = BackgroundColor;

        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self addSubview:self.titleLable];
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.text = @"证监会";
        self.titleLable.font = FONT15;

        //detailLable
        self.detailLable = [[UILabel alloc] init];
        [self addSubview:self.detailLable];
        self.detailLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.detailLable.text = @"xxx 人看过";
        self.detailLable.font = FONT12;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //titleImage
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).with.offset(10);
        make.width.mas_equalTo((SCREENWITH / 2) - 20);
        make.height.equalTo(self.titleImage.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];
    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImage.mas_bottom);
        make.left.right.equalTo(self.titleImage);
        make.height.mas_equalTo(30);
    }];

    //detailLable
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom);
        make.left.right.equalTo(self.titleLable);
        make.height.mas_equalTo(15);
    }];
}

- (void)setModel:(TalkGridModel *)model {
    if (model) {
        _model = model;
    }
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLable.text = model.title;
    self.detailLable.text = [NSString stringWithFormat:@"%@ 人看过",model.video_view];
}

@end
