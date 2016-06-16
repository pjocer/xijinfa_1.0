//
//  AppGridViewCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AppGridViewCell.h"

//@interface AppGridViewCell ()
//
//@property (nonatomic, strong) UIImageView *imageTag;
//@property (nonatomic, strong) UILabel *titleLable;
//
//@end

@implementation AppGridViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        //imageView
        self.imageTag = [[UIImageView alloc] init];
        [self addSubview:self.imageTag];
        self.imageTag.layer.masksToBounds = YES;
        self.imageTag.layer.cornerRadius = 22.5;

        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self addSubview:self.titleLable];
        self.titleLable.textColor = NormalColor;
        BackgroundColor
        self.titleLable.font = FONT13;
        self.titleLable.textAlignment = NSTextAlignmentCenter;


    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //imageView
    [self.imageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    //titleLable
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageTag.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 15));
    }];

}


@end
