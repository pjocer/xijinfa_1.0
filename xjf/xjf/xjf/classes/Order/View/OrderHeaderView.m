//
//  OrderHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        CGFloat labelW = (self.frame.size.width - 20) / 2;
        CGFloat labelH = 14;
        CGFloat padding = 10;

        self.orderNumber = [[UILabel alloc] init];
        [self addSubview:self.orderNumber];
        self.orderNumber.font = FONT12;
        self.orderNumber.textColor = AssistColor;
        self.orderNumber.text = @"订单编号: xxxxxx";
        self.orderNumber.textAlignment = kCTTextAlignmentLeft;
        [self.orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(labelW, labelH));
        }];

        self.orderDate = [[UILabel alloc] init];
        [self addSubview:self.orderDate];
        self.orderDate.font = FONT12;
        self.orderDate.textColor = AssistColor;
        self.orderDate.text = @"2016-00-00 13:11";
        self.orderDate.textAlignment = NSTextAlignmentRight;
        [self.orderDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-padding);
            make.size.mas_equalTo(CGSizeMake(labelW, labelH));
        }];

        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        bottomView.backgroundColor = BackgroundColor;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];

    }
    return self;
}

- (void)setModel:(OrderDataModel *)model
{
    if (model) {
        _model = model;
    }
    self.orderNumber.text = [NSString stringWithFormat:@"订单编号: %@",model.id];
    self.orderDate.text = [NSString stringWithFormat:@"%@",model.created_at];
}

@end
