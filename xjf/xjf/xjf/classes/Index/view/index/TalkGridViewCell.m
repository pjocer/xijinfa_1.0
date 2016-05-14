//
//  TalkGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TalkGridViewCell.h"

@interface TalkGridViewCell ()

@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;

@end

@implementation TalkGridViewCell

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
        self.titleImage.backgroundColor = [UIColor orangeColor];
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
    //titleImage
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.backgroundView).with.offset(10);
        make.right.mas_equalTo(self.backgroundView).with.offset(-10);
        make.height.equalTo(self.titleImage.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
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


@end
