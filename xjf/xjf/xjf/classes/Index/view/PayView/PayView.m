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

@interface PayView ()
@property (nonatomic, weak) id <PayViewDelegate>delegate;
@property (nonatomic, strong) UILabel *background;
@end

@implementation PayView

+(void)showWithTarget:(id<PayViewDelegate>)target {
    PayView *view = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:target options:nil] lastObject];
    view.delegate = target;
    [view show];
}
- (void)show {
    self.background = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.background.backgroundColor = [UIColor blackColor];
    self.background.alpha = 0;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.background];
    self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWITH, 282);
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.background.alpha = 0.35;
        self.frame = CGRectMake(0, SCREENHEIGHT-282, SCREENWITH, 282);
    } completion:nil];
}
- (void)hidden:(PayStyle)type {
    [UIView animateWithDuration:0.3 animations:^{
        self.background.alpha = 0;
        self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWITH, 282);
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];
        if (type != UnKnown) {
            [self.delegate payView:self DidSelectedBy:type];
            [self removeFromSuperview];
        }
    }];
}
- (IBAction)alipay:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:DidSelectedBy:)]) {
        [self hidden:Alipay];
    }
}
- (IBAction)wechatPay:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:DidSelectedBy:)]) {
        [self hidden:WechatPay];
    }
}
- (IBAction)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:DidSelectedBy:)]) {
        [self hidden:UnKnown];
    }
}
@end


