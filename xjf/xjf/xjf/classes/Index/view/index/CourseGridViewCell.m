//
//  CourseGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CourseGridViewCell.h"

@interface CourseGridViewCell ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;
@property (nonatomic, strong) UIImageView *accessoryView;
@end

@implementation CourseGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        [self addSubview:self.backgroundView];

        //titleImage
        self.titleImage = [[UIImageView alloc] init];
        [self addSubview:self.titleImage];
        self.titleImage.backgroundColor = BackgroundColor;
        
        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self addSubview:self.titleLable];
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.font = FONT15;
        
        //detailLable
        self.detailLable = [[UILabel alloc] init];
        [self addSubview:self.detailLable];
        self.detailLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.detailLable.font = FONT12;
        
        //accessoryView
        self.accessoryView = [[UIImageView alloc] init];
        [self addSubview:self.accessoryView];
        self.accessoryView.image = [UIImage imageNamed:@"disclosureIndicator"];
        
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
        make.centerY.mas_equalTo(self.backgroundView);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    
    }];
    
    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImage.mas_right).with.offset(15);
        make.right.equalTo(self.backgroundView).with.offset(-30);
        make.bottom.mas_equalTo(self.backgroundView.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    //detailLable
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.size.mas_equalTo(self.titleLable);
        make.top.mas_equalTo(self.titleLable.mas_bottom).with.offset(9);
    }];
    
    //accessoryView
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-10);
        make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12.5, 21));
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
