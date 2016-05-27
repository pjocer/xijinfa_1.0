//
//  SubmitOrdersView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SubmitOrdersView.h"

@interface SubmitOrdersView ()
@property(nonatomic, strong) UILabel *aCombinedLabel;
@end

@implementation SubmitOrdersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        //selectedLabel;
        self.selectedLabel = [[UILabel alloc] init];
        [self addSubview:self.selectedLabel];
        [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        self.selectedLabel.layer.borderWidth = 1;
        self.selectedLabel.layer.masksToBounds = YES;
        self.selectedLabel.layer.cornerRadius = 7;
        self.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;

        //selectedButton;
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.selectedLabel.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 18));
        }];
        [self.selectedButton setTitle:@"全选" forState:UIControlStateNormal];
        self.selectedButton.titleLabel.font = FONT15;
        self.selectedButton.tintColor = [UIColor blackColor];

        //submitOrdersButton;
        self.submitOrdersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.submitOrdersButton];
        [self.submitOrdersButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(100);
        }];
        self.submitOrdersButton.backgroundColor = [UIColor redColor];
        [self.submitOrdersButton setTitle:@"提交订单" forState:UIControlStateNormal];
        self.submitOrdersButton.titleLabel.font = FONT15;
        self.submitOrdersButton.tintColor = [UIColor blackColor];

        //price;
        self.price = [[UILabel alloc] init];
        [self addSubview:self.price];
        [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.submitOrdersButton.mas_left).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(44, 18));
        }];
        self.price.textColor = [UIColor redColor];
        self.price.text = @"￥000";
        self.price.font = FONT15;

        //aCombinedLabel
        self.aCombinedLabel = [[UILabel alloc] init];
        [self addSubview:self.aCombinedLabel];
        [self.aCombinedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.price.mas_left);
            make.size.mas_equalTo(CGSizeMake(44, 18));
        }];
        self.aCombinedLabel.text = @"合计:";
        self.aCombinedLabel.font = FONT15;

    }
    return self;
}


@end
