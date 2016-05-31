//
//  OrderFooterView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        CGFloat backGroudViewH = 35;
        CGFloat labelW = 60;
        CGFloat labelH = 14;
        CGFloat padding = 10;


        self.PaySuccesView = [[UIView alloc] init];
        [self addSubview:self.PaySuccesView];
        self.PaySuccesView.backgroundColor = [UIColor whiteColor];
        [self.PaySuccesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.1);
        }];
        self.PaySuccesView.hidden = YES;

        self.payStyle = [[UILabel alloc] init];
        [self.PaySuccesView addSubview:self.payStyle];
        self.payStyle.font = FONT12;
        self.payStyle.textColor = AssistColor;
        self.payStyle.text = @"支付方式";
        self.payStyle.textAlignment = kCTTextAlignmentLeft;
        [self.payStyle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.PaySuccesView);
            make.left.equalTo(self).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(labelW, labelH));
        }];
        self.payStyle.hidden = YES;

        self.payStyleName = [[UILabel alloc] init];
        [self.PaySuccesView addSubview:self.payStyleName];
        self.payStyleName.font = FONT15;
        self.payStyleName.text = @"xxxx";
        self.payStyleName.textAlignment = NSTextAlignmentRight;
        [self.payStyleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.PaySuccesView);
            make.right.equalTo(self).with.offset(-padding);
            make.height.mas_equalTo(labelH);
            make.left.equalTo(self.payStyle.mas_right).with.offset(10);
        }];
        self.payStyleName.hidden = YES;

        UIView *backGroudView = [[UIView alloc] init];
        [self addSubview:backGroudView];
        backGroudView.backgroundColor = [UIColor whiteColor];
        [backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.PaySuccesView.mas_bottom).with.offset(1);
            make.height.mas_equalTo(backGroudViewH - 1);
        }];


        self.orderStatus = [[UILabel alloc] init];
        [self addSubview:self.orderStatus];
        self.orderStatus.font = FONT12;
        self.orderStatus.textColor = AssistColor;
        self.orderStatus.text = @"订单待支付";
        self.orderStatus.textAlignment = kCTTextAlignmentLeft;
        [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backGroudView);
            make.left.equalTo(self).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(labelW, labelH));
        }];

        self.orderDescription = [[UILabel alloc] init];
        [self addSubview:self.orderDescription];
        self.orderDescription.font = FONT15;
        self.orderDescription.text = @"共x件商品 实际付款:￥xx";
        self.orderDescription.textAlignment = NSTextAlignmentRight;
        [self.orderDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backGroudView);
            make.right.equalTo(self).with.offset(-padding);
            make.height.mas_equalTo(labelH);
            make.left.equalTo(self.orderStatus.mas_right).with.offset(10);
        }];


    }
    return self;
}
- (void)setModel:(OrderDataModel *)model
{
    if (model) {
        _model = model;
    }
    //    "status": 0, // 订单状态 1待支付，2取消订单，4订单冲突（已支付） 9支付成功
    if (model.status == 9) {
        self.orderStatus.text = @"订单已完成";
    }
    else if (model.status == 1) {
        self.orderStatus.text = @"订单待支付";
    }
    else if (model.status == 2) {
        self.orderStatus.text = @"订单已取消";
    }
    else if (model.status == 4) {
        self.orderStatus.text = @"订单冲突（已支付)";
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if ([self.orderStatus.text isEqualToString:@"订单已完成"]) {
        [self.PaySuccesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(35);
        }];
        self.payStyleName.hidden = NO;
        self.payStyle.hidden = NO;
        self.PaySuccesView.hidden = NO;
    }
}

@end
