//
//  MyMoneyHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyMoneyHeaderView.h"

@interface MyMoneyHeaderView ()
@property (nonatomic, strong) UIView *headerView;
///我的余额
@property (nonatomic, strong) UILabel *myMoney;
@property (nonatomic, strong) UILabel *myMoneyCount;
///我的金币
@property (nonatomic, strong) UILabel *myGoldCOINS;
@property (nonatomic, strong) UILabel *mymyGoldCOINSCount;
///我的优惠卷
@property (nonatomic, strong) UILabel *myCoupons;
@property (nonatomic, strong) UILabel *myCouponsCount;
///查看订单
@property (nonatomic, strong) UILabel *LookOrder;
@property (nonatomic, strong) UILabel *myOrderlabel;

@end

@implementation MyMoneyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat headerViewH = 100;
    CGFloat bottomViewH = 35;
    CGFloat topClearance = 37;
    CGFloat countLeft = 20;
    CGFloat countLabelW = 80;
    CGFloat countLabelH = 27;
    CGFloat headerLabelH = 18;


    self = [super initWithFrame:frame];
    if (self) {

        //headerView
        self.headerView = [[UIView alloc] init];
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(10);
            make.height.mas_offset(headerViewH);
        }];
        self.headerView.backgroundColor = [UIColor whiteColor];

        self.bottomView = [[UIView alloc] init];
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_offset(bottomViewH);
        }];
        self.bottomView.backgroundColor = [UIColor whiteColor];


        self.mymyGoldCOINSCount = [[UILabel alloc] init];
        [self addSubview:self.mymyGoldCOINSCount];
        self.mymyGoldCOINSCount.font = [UIFont systemFontOfSize:25];
        self.mymyGoldCOINSCount.text = @"00";
        self.mymyGoldCOINSCount.textAlignment = NSTextAlignmentCenter;
        [self.mymyGoldCOINSCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(topClearance);
            make.size.mas_equalTo(CGSizeMake(countLabelW, countLabelH));
        }];

        self.myGoldCOINS = [[UILabel alloc] init];
        [self addSubview:self.myGoldCOINS];
        self.myGoldCOINS.text = @"我的金币";
        self.myGoldCOINS.font = FONT15;
        self.myGoldCOINS.textAlignment = NSTextAlignmentCenter;
        self.myGoldCOINS.textColor = AssistColor;
        [self.myGoldCOINS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mymyGoldCOINSCount);
            make.bottom.mas_equalTo(self.headerView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(countLabelW, headerLabelH));
        }];

        self.myMoneyCount = [[UILabel alloc] init];
        [self addSubview:self.myMoneyCount];
        self.myMoneyCount.font = [UIFont systemFontOfSize:25];
        self.myMoneyCount.text = @"00";
        self.myMoneyCount.textAlignment = NSTextAlignmentCenter;
        [self.myMoneyCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mymyGoldCOINSCount);
            make.left.mas_equalTo(countLeft);
            make.size.mas_equalTo(CGSizeMake(countLabelW, countLabelH));
        }];

        self.myMoney = [[UILabel alloc] init];
        [self addSubview:self.myMoney];
        self.myMoney.text = @"我的余额";
        self.myMoney.font = FONT15;
        self.myMoney.textAlignment = NSTextAlignmentCenter;
        self.myMoney.textColor = AssistColor;
        [self.myMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.myMoneyCount);
            make.bottom.mas_equalTo(self.headerView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(countLabelW, headerLabelH));
        }];

        self.myCouponsCount = [[UILabel alloc] init];
        [self addSubview:self.myCouponsCount];
        self.myCouponsCount.font = [UIFont systemFontOfSize:25];
        self.myCouponsCount.text = @"00";
        self.myCouponsCount.textAlignment = NSTextAlignmentCenter;
        [self.myCouponsCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myMoneyCount);
            make.right.mas_equalTo(-countLeft);
            make.size.mas_equalTo(CGSizeMake(countLabelW, countLabelH));
        }];

        self.myCoupons = [[UILabel alloc] init];
        [self addSubview:self.myCoupons];
        self.myCoupons.text = @"我的优惠卷";
        self.myCoupons.font = FONT15;
        self.myCoupons.textAlignment = NSTextAlignmentCenter;
        self.myCoupons.textColor = AssistColor;
        [self.myCoupons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.myCouponsCount);
            make.bottom.mas_equalTo(self.headerView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(countLabelW, headerLabelH));
        }];


        //bottomView
        self.bottomView = [[UIView alloc] init];
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom).with.offset(10);
            make.bottom.equalTo(self);
        }];
        self.bottomView.backgroundColor = [UIColor whiteColor];

        self.myOrderlabel = [[UILabel alloc] init];
        [self addSubview:self.myOrderlabel];
        self.myOrderlabel.font = FONT15;
        self.myOrderlabel.text = @"我的订单";
        [self.myOrderlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(60, 18));
        }];

        self.LookOrder = [[UILabel alloc] init];
        [self addSubview:self.LookOrder];
        self.LookOrder.font = FONT12;
        self.LookOrder.textAlignment = kCTCenterTextAlignment;
        self.LookOrder.text = @"查看所有订单";
        [self.LookOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self.bottomView);
            make.size.mas_equalTo(CGSizeMake(80, 14));
        }];
        self.LookOrder.textColor = BlueColor;

    }
    return self;
}

@end
