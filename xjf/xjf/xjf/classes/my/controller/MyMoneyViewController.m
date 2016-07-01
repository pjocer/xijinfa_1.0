//
//  MyMoneyViewController.m
//  xjf
//
//  Created by PerryJ on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyMoneyViewController.h"
#import <objc/runtime.h>
#import "XjfRequest.h"
#import "XJMarket.h"
#import "XJOrder.h"
#import "PayView.h"
#import "XJAccountManager.h"
#import "ZToastManager.h"
@interface MyMoneyViewController () <OrderInfoDidChangedDelegate,PayViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *first;
@property (weak, nonatomic) IBOutlet UIView *second;
@property (weak, nonatomic) IBOutlet UIView *fouth;
@property (weak, nonatomic) IBOutlet UIView *third;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) PayStyle style;
@property (strong, nonatomic) NSArray *views;
@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    
}
- (void)initControl {
    self.views = @[_first,_second,_third,_fouth];
    NSArray *limits = @[@"300",@"500",@"800",@"1000"];
    for (int i = 0; i < self.views.count; i++) {
        UIView *view= self.views[i];
        NSString *limit = limits[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseLimit:)];
        view.tag = 880+i;
        objc_setAssociatedObject(view,@"limit", limit, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [view addGestureRecognizer:tap];
    }
}
- (IBAction)confirmRecharge:(UIButton *)sender {
    if ([[XJAccountManager defaultManager] accessToken]) {
        [PayView showWithTarget:self];
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }
}
- (void)orderInfoDidChanged:(XJOrder *)order {
    [[XJMarket sharedMarket] buyTradeImmediately:order by:self.style success:^{
        NSLog(@"支付成功");
    } failed:^{
        NSLog(@"支付失败");
    }];
}
- (void)chooseLimit:(UITapGestureRecognizer *)tap {
    self.params = [NSMutableDictionary dictionaryWithDictionary:@{@"amount":objc_getAssociatedObject(tap.view, @"limit")}];
    for (UIView *view in self.views) {
        if (view.tag != tap.view.tag) {
            view.layer.borderWidth = 0;
            view.layer.borderColor = [[UIColor clearColor] CGColor];
        }
    }
    tap.view.layer.borderWidth = 1;
    tap.view.layer.borderColor = [[UIColor xjfStringToColor:@"#ff4c00"] CGColor];
}
-(void)payView:(PayView *)payView DidSelectedBy:(PayStyle)type {
    self.style = type;
    [[XJMarket sharedMarket] createVipOrderWith:self.params target:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
