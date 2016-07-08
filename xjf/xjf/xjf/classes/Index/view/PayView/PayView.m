//
//  PayView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PayView.h"
#import "MyOrderViewController.h"
#import "XJAccountManager.h"
#import "XJMarket.h"

@interface PayView () <OrderInfoDidChangedDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vertical;
@property (weak, nonatomic) IBOutlet UIView *balancePayView;
@property (nonatomic, weak) id <PayViewDelegate>delegate;
@property (nonatomic, strong) UILabel *background;
@property (nonatomic, strong) XJOrder *order;
@property (nonatomic, assign) PayStyle payStyle;
@property (nonatomic, assign) PayViewType type;
@end

@implementation PayView

+(void)showWithTarget:(id<PayViewDelegate>)target type:(PayViewType)type{
    PayView *view = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:target options:nil] firstObject];
    view.delegate = target;
    view.type = type;
    [view show];
}
- (void)show {
    self.background = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.background.backgroundColor = [UIColor blackColor];
    self.background.alpha = 0;
    self.background.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClickedAction)];
    [self.background addGestureRecognizer:tap];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.background];
    if (self.type == PayViewDefault) {
        self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWITH, 388);
    }
    if (self.type == PayViewWithoutBalance) {
        self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWITH, 287);
        self.balancePayView.hidden = YES;
        self.vertical.constant = 1;
    }
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.background.alpha = 0.35;
        self.frame = CGRectMake(0, self.type==PayViewDefault?SCREENHEIGHT-388:SCREENHEIGHT-287, SCREENWITH, self.type==PayViewDefault?388:287);
    } completion:nil];
}
- (void)payViewhidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.background.alpha = 0;
            self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWITH, self.type==PayViewDefault?388:287);
        } completion:^(BOOL finished) {
        }];
    });
}
- (void)releaseSelf {
    [self removeFromSuperview];
    [self.background removeFromSuperview];
    self.delegate = nil;
}
- (void)orderInfoDidChanged:(XJOrder *)order {
    [[XJMarket sharedMarket] buyTradeImmediately:self.order by:self.payStyle success:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(payViewDidPaySuccessed:)]) {
            [self.delegate payViewDidPaySuccessed:self];
            [self releaseSelf];
        }
    } failed:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(payViewDidPayFailed:)]) {
            [self.delegate payViewDidPayFailed:self];
            [self releaseSelf];
        }
    }];
}
- (IBAction)balancePay:(UITapGestureRecognizer *)sender {
    [self handleDelegate:BalancePay];
}
- (IBAction)alipay:(UITapGestureRecognizer *)sender {
    [self handleDelegate:Alipay];
}
- (IBAction)wechatPay:(UITapGestureRecognizer *)sender {
    [self handleDelegate:WechatPay];
}
- (void)handleDelegate:(PayStyle)style {
    self.payStyle = style;
    if (self.delegate && [self.delegate respondsToSelector:@selector(paramsForCurrentpayView:)]) {
        id params = [self.delegate paramsForCurrentpayView:self];
        NSAssert((params), @"Invalid parameter not satisfying: %@", params);
        if ([params isKindOfClass:[NSDictionary class]]) {
            self.order = [[XJMarket sharedMarket] createRechargeOrderWith:(NSDictionary *)params target:self];
        }
        if ([params isKindOfClass:[NSArray class]]) {
            self.order = [[XJMarket sharedMarket] createOrderWith:(NSArray *)params target:self];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:DidSelectedBy:)]) {
        [self.delegate payView:self DidSelectedBy:style];
    }
    [self payViewhidden];
}
- (IBAction)cancel:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payViewDidCanceled:)]) {
        [self.delegate payViewDidCanceled:self];
    }
    [self payViewhidden];
}
- (void)backgroundClickedAction {
    [self payViewhidden];
}
@end


