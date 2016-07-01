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

- (void)awakeFromNib {
    self.backgroundColor = BackgroundColor;
}
+(void)showWithTarget:(id<PayViewDelegate>)target {
    PayView *view = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:target options:nil] lastObject];
    view.delegate = target;
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)target;
        view.frame = CGRectMake(0, controller.view.bounds.size.height, controller.view.bounds.size.width, 282);
        [controller.view addSubview:view];
    }else {
        UIViewController *controller = getCurrentDisplayController();
        view.frame = CGRectMake(0, controller.view.bounds.size.height, controller.view.bounds.size.width, 282);
        [controller.view addSubview:view];
    }
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
        if (type != UnKnown) {
            [self.delegate payView:self DidSelectedBy:type];
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


