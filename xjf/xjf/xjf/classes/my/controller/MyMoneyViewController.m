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
#import "RechargeStream.h"
#import "RechargeList.h"
#import "RechargeResultController.h"
@interface MyMoneyViewController () <OrderInfoDidChangedDelegate,PayViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *first;
@property (weak, nonatomic) IBOutlet UIView *second;
@property (weak, nonatomic) IBOutlet UIView *fouth;
@property (weak, nonatomic) IBOutlet UIView *third;
@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *ThirdTitle;
@property (weak, nonatomic) IBOutlet UILabel *FourthTitle;
@property (weak, nonatomic) IBOutlet UILabel *FirstContent;
@property (weak, nonatomic) IBOutlet UILabel *SecondContent;
@property (weak, nonatomic) IBOutlet UILabel *ThirdContent;
@property (weak, nonatomic) IBOutlet UILabel *FourthContent;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) PayStyle style;
@property (strong, nonatomic) NSArray *views;
@property (strong, nonatomic) XJOrder *order;
@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"recharge_right"] style:UIBarButtonItemStylePlain target:self action:@selector(rechargeStream)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.title = @"我的余额";
    self.balance.text = [NSString stringWithFormat:@"%.2f",[[[[XJAccountManager defaultManager] user_model] result] account_balance]*0.01f];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:recharge_list RequestMethod:GET];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        RechargeList *model = [[RechargeList alloc] initWithData:responseData error:nil];
        if (model.errCode == 0) {
            [self initControl:model.result.deal];
        }else {
            [[ZToastManager ShardInstance] showtoast:@"获取充值列表失败"];
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}
- (void)rechargeStream {
    RechargeStream *stream = [[RechargeStream alloc] init];
    [self.navigationController pushViewController:stream animated:YES];
}
- (void)initControl:(NSMutableArray *)limits {
    self.views = @[_first,_second,_third,_fouth];
    NSArray *contents = @[_FirstContent,_SecondContent,_ThirdContent,_FourthContent];
    NSArray *titles = @[_firstTitle,_secondTitle,_ThirdTitle,_FourthTitle];
    for (int i = 0; i < self.views.count; i++) {
        UIView *view= self.views[i];
        UILabel *contentLabel = contents[i];
        UILabel *titleLabel = titles[i];
        RechargeDeal *deal = limits[i];
        contentLabel.text = deal.title;
        titleLabel.text = [NSString stringWithFormat:@"¥ %.2f",deal.amount/100.0f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseLimit:)];
        view.tag = 880+i;
        objc_setAssociatedObject(view,@"limit", @(deal.amount), OBJC_ASSOCIATION_ASSIGN);
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
        [[XJAccountManager defaultManager] updateUserInfoCompeletionBlock:^(UserProfileModel *model) {
            _balance.text = [NSString stringWithFormat:@"%.2f",model.result.account_balance*0.01f];
            RechargeResultController *result = [[RechargeResultController alloc] initWithSuccess:YES orderID:self.order.order.result.id];
            [self.navigationController pushViewController:result animated:YES];
        }];
    } failed:^{
        RechargeResultController *result = [[RechargeResultController alloc] initWithSuccess:NO orderID:nil];
        [self.navigationController pushViewController:result animated:YES];
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
    self.order =[[XJMarket sharedMarket] createRechargeOrderWith:self.params target:self];
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
