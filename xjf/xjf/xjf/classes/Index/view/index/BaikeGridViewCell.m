//
//  BaikeGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaikeGridViewCell.h"

@interface BaikeGridViewCell ()

@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *teacherLable;
@property (nonatomic, strong) UILabel *classesLable;

@end

@implementation BaikeGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        //titleImage
        self.titleImage = [[UIImageView alloc] init];
        [self addSubview:self.titleImage];
        self.titleImage.backgroundColor = BackgroundColor;
        
        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self addSubview:self.titleLable];
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.text = @"XXXXXXXXXXXXXXXXXXXXXXXXXX";
        self.titleLable.numberOfLines = 2;
        self.titleLable.font = FONT15;

        //teacherLable
        self.teacherLable = [[UILabel alloc] init];
        [self addSubview:self.teacherLable];
        self.teacherLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.teacherLable.text = @"主讲: xxxx";
        self.teacherLable.font = FONT12;
        
        //classesLable
        self.classesLable = [[UILabel alloc] init];
        [self addSubview:self.classesLable];
        self.classesLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.classesLable.text = @"课时: xxxx";
        self.classesLable.font = FONT12;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //titleImage
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(self).with.offset(10);
//        make.bottom.mas_equalTo(self).with.offset(-10);
//        make.height.mas_equalTo(tempHeight);
//        make.width.equalTo(self.titleImage.mas_height).multipliedBy(16.0f/9.0f).with.priority(750);
        make.top.left.mas_equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
        make.width.mas_equalTo((SCREENWITH / 2) - 20);
 
    }];

    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImage);
        make.left.mas_equalTo(self.titleImage.mas_right).with.offset(10);
        make.right.mas_equalTo(self.backgroundView).with.offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    //teacherLable
    [self.teacherLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLable);
        make.top.mas_equalTo(self.titleLable.mas_bottom).with.offset(7);
        make.width.mas_equalTo(self.titleLable);
        make.height.mas_equalTo(15);
    }];
    
    //classesLable
    [self.classesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLable);
        make.top.mas_equalTo(self.teacherLable.mas_bottom).with.offset(3);
        make.width.mas_equalTo(self.titleLable);
        make.height.mas_equalTo(15);
    }];
}

- (void)setModel:(TalkGridModel *)model
{
    if (model) {
        _model = model;
    }
   
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLable.text = model.title;
    self.classesLable.text = [NSString stringWithFormat:@"课时: %@",model.lessons_count];
    if (model.taxonomy_gurus.count != 0 && model.taxonomy_gurus) {
        taxonomy_gurus *gurus = model.taxonomy_gurus.firstObject;
        self.teacherLable.text = [NSString stringWithFormat:@"主讲: %@",gurus.title];
    }
}

@end
