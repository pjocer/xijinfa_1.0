//
//  AppGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AppGridViewCell.h"

@interface AppGridViewCell ()

@property (nonatomic, strong) UIImageView *imageTag;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;

@end

@implementation AppGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.backgroundView.backgroundColor = [UIColor whiteColor ];
        [self addSubview:self.backgroundView];
     
        //imageView
        self.imageTag = [[UIImageView alloc] init];
        self.imageTag.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.imageTag];
        
        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self addSubview:self.titleLable];
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.font = FONT15;
        self.titleLable.text = @"XXXXX";
        
        //detailLable
        self.detailLable = [[UILabel alloc] init];
        [self addSubview:self.detailLable];
        self.detailLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.detailLable.text = @"xxxxxx";
        self.detailLable.font = FONT12;
    
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //imageView
    [self.imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageTag);
        make.left.equalTo(self.imageTag.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(self.imageTag).multipliedBy(0.5);
    }];
    //titleLable
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.bottom.equalTo(self.imageTag);
        make.size.mas_equalTo(self.titleLable);
    }];
}


@end
