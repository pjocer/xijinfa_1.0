//
//  LessonIndexCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonIndexCell.h"

@interface LessonIndexCell ()

@property(nonatomic, strong) UIImageView *titleImage;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *detailLable;

@end


@implementation LessonIndexCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //titleImage
        self.titleImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.titleImage];

        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLable];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.font = FONT15;

        //detailLable
        self.detailLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.detailLable];
        self.detailLable.textAlignment = NSTextAlignmentLeft;
        self.detailLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.detailLable.font = FONT12;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //titleImage
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImage.mas_right).with.offset(10);
        make.bottom.equalTo(self.titleImage.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(20);
    }];

    //detailLable
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImage.mas_right).with.offset(10);
        make.top.equalTo(self.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
}

- (void)setModel:(ProjectList *)model {
    if (model) {
        _model = model;
    }
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLable.text = model.title;
    self.detailLable.text = model.summary;
}

@end
