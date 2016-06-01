//
//  TeacherGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherGridViewCell.h"

@interface TeacherGridViewCell ()

@property (nonatomic, strong) UIImageView *teacherImage;
@property (nonatomic, strong) UILabel *teacherName;
@property (nonatomic, strong) UILabel *teacherDetail;

@end

@implementation TeacherGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        //teacherImage
        self.teacherImage = [[UIImageView alloc] init];
        [self addSubview:self.teacherImage];
        self.teacherImage.backgroundColor = [UIColor orangeColor];
        self.teacherImage.backgroundColor = BackgroundColor;
        self.teacherImage.layer.masksToBounds = YES;
        self.teacherImage.layer.cornerRadius = 27.5;
        
        //teacherName
        self.teacherName = [[UILabel alloc] init];
        [self addSubview:self.teacherName];
        self.teacherName.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.teacherName.text = @"XXXX";
        self.teacherName.textAlignment = NSTextAlignmentCenter;
        self.teacherName.font = FONT15;
        
        //teacherDetail
        self.teacherDetail = [[UILabel alloc] init];
        [self addSubview:self.teacherDetail];
        self.teacherDetail.text = @"xxxxxxxxxxxx";
        self.teacherDetail.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.teacherDetail.textAlignment = NSTextAlignmentCenter;
        self.teacherDetail.font = FONT12;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    //teacherImage
    [self.teacherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backgroundView.mas_centerY);
        make.centerX.mas_equalTo(self.backgroundView);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    //teacherDetail
    [self.teacherDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teacherImage);
        make.bottom.mas_equalTo(self.backgroundView).with.offset(-10);
        make.width.mas_equalTo(self.backgroundView);
        make.height.mas_equalTo(15);
    }];
    
    //teacherName
    [self.teacherName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teacherImage);
        make.bottom.mas_equalTo(self.teacherDetail).with.offset(-10);
        make.width.mas_equalTo(self.backgroundView);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setModel:(TeacherListData *)model
{
    if (model) {
        _model = model;
    }
    [self.teacherImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.teacherName.text = model.title;
    self.teacherDetail.text = model.summary;
}


@end
