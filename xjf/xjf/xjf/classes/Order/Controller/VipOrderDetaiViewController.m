//
//  VipOrderDetaiViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VipOrderDetaiViewController.h"
#import "PayView.h"
#import "XJMarket.h"
#import "VideoListCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "MyViewController.h"
#import "AlertUtils.h"
#import "MyOrderViewController.h"
#import "XJAccountManager.h"
@interface VipOrderDetaiViewController ()<UITableViewDelegate, UITableViewDataSource,OrderInfoDidChangedDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *cancel;
@property(nonatomic, strong) UIButton *nowPay;
@property(nonatomic, strong) PayView *payView;
@property(nonatomic, assign) PayStyle style;
@property(nonatomic, strong) UIView *payingBackGroudView;
@property(nonatomic, strong) OrderHeaderView *orderheaderView;
@property(nonatomic, strong) OrderFooterView *orderfooterView;
@property(nonatomic, strong) XJOrder *order;
@end

@implementation VipOrderDetaiViewController
static CGFloat BottomPayButtonH = 50;
static CGFloat payViewH = 285;
static CGFloat tableHeader_NormalH = 35;
static CGFloat tableFooter_NormalH = 45;
static CGFloat tableFooter_orderSucceslH = 80;
static NSString *VipOrderDetaiCell_id = @"VipOrderDetaiCell_id";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"订单详情";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

#pragma mark - initMainUI
- (void)initMainUI {
    [self setTableView];
    [self nowPayOrCancel];
}

#pragma mark --setTableView--

- (void)setTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-BottomPayButtonH);
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (iPhone5) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:VipOrderDetaiCell_id];
}



#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VipOrderDetaiCell_id];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.vipModel = self.vipModel;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableHeader_NormalH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.orderDataModel.status == 1) {
//        return tableFooter_orderSucceslH;
//    }
    return tableFooter_NormalH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.orderheaderView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
//    self.orderheaderView.model = self.orderDataModel;
    self.orderheaderView .orderNumber.text = [NSString getSystemDate];
    self.orderheaderView .orderDate.text = @"";
    return self.orderheaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.orderfooterView = [[OrderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
//    self.orderfooterView.model = self.orderDataModel;
//    CGFloat temp = 0;
//    if (self.dataSource.count != 0) {
//        for (TalkGridModel *model in self.dataSource) {
//            temp += model.price.floatValue;
//        }
//        self.orderfooterView.orderDescription.text = [NSString stringWithFormat:@"共x%ld件商品 实际付款:￥%.2lf",self.dataSource.count,temp/100];
//    }else {
//        for (TalkGridModel *model in self.orderfooterView.model.items) {
//            temp += model.price.floatValue;
//        }
//        self.orderfooterView.orderDescription.text = [NSString stringWithFormat:@"共x%ld件商品 实际付款:￥%.2lf",self.orderfooterView.model.items.count,temp/100];
//    }
    
      self.orderfooterView.orderDescription.text = [NSString stringWithFormat:@"共1件商品 实际付款:￥%.2lf",[self.vipModel.price floatValue] / 100];
    
    return self.orderfooterView;
}


#pragma mark --nowPayOrCancel--
- (void)nowPayOrCancel {
    self.cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.cancel];
    self.cancel.frame = CGRectMake(0,
                                   self.view.frame.size.height - BottomPayButtonH - HEADHEIGHT,
                                   self.view.frame.size.width / 2,
                                   BottomPayButtonH);
    self.cancel.backgroundColor = AssistColor;
    [self.cancel setTitle:@"取消订单" forState:UIControlStateNormal];
    self.cancel.tintColor = [UIColor whiteColor];
    self.cancel.titleLabel.font = FONT15;
    [self.cancel
     addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nowPay = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.nowPay];
    self.nowPay.frame = CGRectMake(CGRectGetMaxX(self.cancel.frame),
                                   self.view.frame.size.height - BottomPayButtonH - HEADHEIGHT,
                                   self.view.frame.size.width / 2,
                                   BottomPayButtonH);
    self.nowPay.backgroundColor = [UIColor redColor];
    [self.nowPay setTitle:@"立即支付" forState:UIControlStateNormal];
    self.nowPay.tintColor = [UIColor whiteColor];
    self.nowPay.titleLabel.font = FONT15;
    [self.nowPay addTarget:self action:@selector(nowPay:)
          forControlEvents:UIControlEventTouchUpInside];
    
    //PayView
    self.payingBackGroudView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.payingBackGroudView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.payingBackGroudView];
    self.payingBackGroudView.hidden = YES;
    self.payingBackGroudView.alpha = 0.2;
    
    self.payView = [[NSBundle mainBundle]
                    loadNibNamed:@"PayView" owner:self options:nil].firstObject;
    self.payView.frame = CGRectMake(0,
                                    self.view.bounds.size.height,
                                    self.view.bounds.size.width,
                                    payViewH);
    [self.view addSubview:self.payView];
    [self.payView.aliPay addTarget:self
                            action:@selector(aliPay:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.payView.WeixinPay addTarget:self
                               action:@selector(WeixinPay:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.payView.cancel addTarget:self
                            action:@selector(payViewCancel:)
                  forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark cancel
- (void)cancel:(UIButton *)sender {
    [AlertUtils alertWithTarget:self title:@"提示" content:@"确定取消订单？" confirmBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark nowPay
- (void)nowPay:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.frame = CGRectMake(0,
                                        self.view.bounds.size.height - payViewH,
                                        self.view.bounds.size.width,
                                        payViewH);
    }];
    self.payingBackGroudView.hidden = NO;
}

#pragma mark - aliPay
- (void)aliPay:(UIButton *)sender {
    [self payByPayStyle:Alipay];
}

#pragma mark - WeixinPay
- (void)WeixinPay:(UIButton *)sender {
    [self payByPayStyle:WechatPay];
}

- (void)payByPayStyle:(PayStyle)stayle {
    self.style = stayle;
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
        [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [[ZToastManager ShardInstance] showtoast:@"只有登录后才可以购买哦"];
    } else {
        self.order = [[XJMarket sharedMarket] createVipOrderWith:self.dicData target:self];
    }
}
-(void)orderInfoDidChanged:(XJOrder *)order {
    [[XJMarket sharedMarket] buyTradeImmediately:order by:self.style success:^{
        [[ZToastManager ShardInstance] showtoast:@"支付成功"];
    } failed:^{
        [[ZToastManager ShardInstance] showtoast:@"支付失败"];
        MyOrderViewController *myOrderPage = [MyOrderViewController new];
        [self.navigationController pushViewController:myOrderPage animated:YES];
    }];
}
#pragma mark - payViewCancel
- (void)payViewCancel:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.frame = CGRectMake(0,
                                        self.view.bounds.size.height,
                                        self.view.bounds.size.width,
                                        payViewH);
    }];
    self.payingBackGroudView.hidden = YES;
}


@end
