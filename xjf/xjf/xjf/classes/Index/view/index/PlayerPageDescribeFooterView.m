//
//  PlayerPageDescribeFooterView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeFooterView.h"

@interface PlayerPageDescribeFooterView ()

@property (nonatomic, strong) UIImageView *thumbUpImage;
///点赞次数
@property (nonatomic, strong) UILabel *thumbUpLabel;

@property (nonatomic, strong) UIView *backGroudView;

@end

@implementation PlayerPageDescribeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 10)];
        [self addSubview:self.backGroudView];
        self.backGroudView.backgroundColor = [UIColor whiteColor];
        
        self.thumbUpImage = [[UIImageView alloc] init];
        [self addSubview:self.thumbUpImage];
        self.thumbUpImage.backgroundColor = [UIColor redColor];
        [self.thumbUpImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        self.thumbUpLabel = [[UILabel alloc] init];
        [self addSubview:self.thumbUpLabel];
        self.thumbUpLabel.font = FONT12;
        self.thumbUpLabel.textColor = AssistColor;
        self.thumbUpLabel.text = @"xxx";
        [self.thumbUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbUpImage);
            make.left.equalTo(self.thumbUpImage.mas_right);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];
    }
    return self;
}


@end
