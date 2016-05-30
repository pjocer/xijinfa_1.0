//
//  MyOrderFooterView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyOrderFooterView.h"

@interface MyOrderFooterView ()
@property(nonatomic, strong) UIView *backGroudView;
@end

@implementation MyOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        CGFloat backGroudViewH = 35;
        CGFloat labelW = 60;
        CGFloat labelH = 14;
        CGFloat padding = 10;
        CGFloat buttonH = 33;
        CGFloat buttonW = 90;

        self.backGroudView = [[UIView alloc] init];
        [self addSubview:_backGroudView];
        _backGroudView.backgroundColor = [UIColor whiteColor];
        [_backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(backGroudViewH - 1);
        }];

        self.orderStatus = [[UILabel alloc] init];
        [self addSubview:self.orderStatus];
        self.orderStatus.font = FONT12;
        self.orderStatus.textColor = AssistColor;
        self.orderStatus.text = @"订单待支付";
        self.orderStatus.textAlignment = kCTTextAlignmentLeft;
        [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backGroudView);
            make.left.equalTo(self).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(labelW, labelH));
        }];

        self.orderDescription = [[UILabel alloc] init];
        [self addSubview:self.orderDescription];
        self.orderDescription.font = FONT15;
        self.orderDescription.text = @"共x件商品 实际付款:￥xx";
        self.orderDescription.textAlignment = NSTextAlignmentRight;
        [self.orderDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backGroudView);
            make.right.equalTo(self).with.offset(-padding);
            make.height.mas_equalTo(labelH);
            make.left.equalTo(self.orderStatus.mas_right).with.offset(10);
        }];


        self.PayUnSuccesView = [[UIView alloc] init];
        self.PayUnSuccesView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.PayUnSuccesView];
        [self.PayUnSuccesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.backGroudView.mas_bottom).with.offset(1);
            make.height.mas_equalTo(0.1);
        }];
        self.PayUnSuccesView.hidden = YES;

        self.goPay = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.goPay];
        [self.goPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.PayUnSuccesView);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(buttonW, buttonH));
        }];
        self.goPay.backgroundColor = [UIColor redColor];
        [self.goPay setTitle:@"去付款" forState:UIControlStateNormal];
        self.goPay.tintColor = [UIColor whiteColor];
        self.goPay.titleLabel.font = FONT15;
        self.goPay.layer.masksToBounds = YES;
        self.goPay.layer.cornerRadius = 4;
        [self.goPay addTarget:self action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        self.goPay.hidden = YES;

        self.cancelOrder = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.cancelOrder];
        [self.cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.PayUnSuccesView);
            make.right.equalTo(self.goPay.mas_left).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(buttonW, buttonH));
        }];
        self.cancelOrder.backgroundColor = AssistColor;
        [self.cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        self.cancelOrder.tintColor = [UIColor whiteColor];
        self.cancelOrder.titleLabel.font = FONT15;
        self.cancelOrder.layer.masksToBounds = YES;
        self.cancelOrder.layer.cornerRadius = 4;
        [self.cancelOrder addTarget:self action:@selector(buttonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
        self.cancelOrder.hidden = YES;
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(MyOrderFootrtView:goPayOrCancelOreder:)]) {
        [_delegate MyOrderFootrtView:self goPayOrCancelOreder:sender];
    }
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

    if ([self.orderStatus.text isEqualToString:@"订单待支付"]) {
        [self.PayUnSuccesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.backGroudView.mas_bottom).with.offset(1);
            make.height.mas_equalTo(50);
        }];
        self.cancelOrder.hidden = NO;
        self.PayUnSuccesView.hidden = NO;
        self.goPay.hidden = NO;
    }
}


@end
