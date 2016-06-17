//
//  TearcherIndexCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TearcherIndexCell.h"

@interface TearcherIndexCell ()
@property (nonatomic, strong) UIImageView *teacherImage;
@property (nonatomic, strong) UILabel *teacherName;
@property (nonatomic, strong) UILabel *teacherDetail;
@end


@implementation TearcherIndexCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        //teacherImage
        self.teacherImage = [[UIImageView alloc] init];
        [self addSubview:self.teacherImage];
        self.teacherImage.backgroundColor = BackgroundColor;
        self.teacherImage.layer.masksToBounds = YES;
        self.teacherImage.layer.cornerRadius = 27.5;

        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self addSubview:self.teacherName];
        self.teacherName.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.teacherName.textAlignment = NSTextAlignmentCenter;
        self.teacherName.font = FONT15;

        //teacherDetail
        self.teacherDetail = [[UILabel alloc] init];
        [self addSubview:self.teacherDetail];
        self.teacherDetail.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.teacherDetail.textAlignment = NSTextAlignmentCenter;
        self.teacherDetail.font = FONT12;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //teacherImage
    [self.teacherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];

    //teacherName
    [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teacherImage);
        make.top.equalTo(self.teacherImage.mas_bottom).with.offset(10);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];

    //teacherDetail
    [self.teacherDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teacherImage);
        make.top.equalTo(self.teacherName.mas_bottom).with.offset(10);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];


}

- (void)setModel:(TeacherListData *)model {
    if (model) {
        _model = model;
    }
    [self.teacherImage sd_setImageWithURL:[NSURL URLWithString:model.guru_avatar]];
    self.teacherName.text = model.title;
    self.teacherDetail.text = model.subtitle;
}

@end
