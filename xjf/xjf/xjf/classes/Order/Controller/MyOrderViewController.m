//
//  MyOrderViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyOrderViewController.h"
#import "PayView.h"
#import "XJMarket.h"
#import "VideoListCell.h"
#import "OrderHeaderView.h"
#import "MyOrderFooterView.h"
#import "OrderDetaiViewController.h"
#import "OrderModel.h"
@interface MyOrderViewController () <UITableViewDelegate, UITableViewDataSource, MyOrderFootrtViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PayView *payView;
@property(nonatomic, strong) UIView *payingBackGroudView;
@property(nonatomic, strong) OrderHeaderView *orderheaderView;
@property(nonatomic, strong) MyOrderFooterView *orderfooterView;

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) NSDictionary *requestParams;
@end

@implementation MyOrderViewController

static CGFloat payViewH = 285;
static CGFloat tableHeader_NormalH = 35;
static CGFloat tableFooter_NormalH = 45;
static CGFloat tableFooter_orderSucceslH = 100;

static NSString *LessonMyOrderCell_id = @"LessonMyOrderCell_id";
static NSString *TeacherMyOrderCell_id = @"TeacherMyOrderCell_id";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"我的订单";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self requestAllOrderData:queryAllOrder method:GET];
}
#pragma mark -requestData
- (void)requestAllOrderData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [[ZToastManager ShardInstance] showprogress];
    if (method == GET) {
        //TalkGridData
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [[ZToastManager ShardInstance] hideprogress];
            __strong typeof(self) sSelf = wSelf;
            sSelf.orderModel = [[OrderModel alloc] initWithData:responseData error:nil];
            [sSelf.tableView reloadData];
            
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
    } else if (method == PUT) {
        request.requestParams = self.requestParams.mutableCopy;
   
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [self requestAllOrderData:queryAllOrder method:GET];
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
    }

}


#pragma mark - initMainUI

- (void)initMainUI {
    [self setTableView];
    [self setPayView];
}

#pragma mark --setTableView--

- (void)setTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

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

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:LessonMyOrderCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderModel.result.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    OrderDataModel *orderDataModel = self.orderModel.result.data[section];
    return orderDataModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonMyOrderCell_id];
    OrderDataModel *orderDataModel = self.orderModel.result.data[indexPath.section];
    cell.model = orderDataModel.items[indexPath.row];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return tableHeader_NormalH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    OrderDataModel *model = self.orderModel.result.data[section];
    if (model.status == 1) {
        return tableFooter_orderSucceslH;
    }
    return tableFooter_NormalH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.orderheaderView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
    self.orderheaderView.model = self.orderModel.result.data[section];
    return self.orderheaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.orderfooterView = [[MyOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
    self.orderfooterView.model = self.orderModel.result.data[section];
    self.orderfooterView.delegate = self;
    return self.orderfooterView;
}

//OrderFooterViewDelegate
- (void)MyOrderFootrtView:(MyOrderFooterView *)orderFooterView goPayOrCancelOreder:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"去付款"]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.payView.frame = CGRectMake(0,
                    self.view.bounds.size.height - payViewH,
                    self.view.bounds.size.width,
                    payViewH);
        }];
        self.payingBackGroudView.hidden = NO;
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [AlertUtils alertWithTarget:self title:@"提示" content:@"确定取消订单？" confirmBlock:^{
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",cancelOrder,orderFooterView.model.id]);
            self.requestParams = @{@"status":[NSString stringWithFormat:@"2"]};
            [self requestAllOrderData:[NSString stringWithFormat:@"%@%@",cancelOrder,orderFooterView.model.id] method:PUT];
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

}

#pragma mark --setPayView--

- (void)setPayView {

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

#pragma mark tableViewDidSelected
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetaiViewController *orderDetail = [OrderDetaiViewController new];
    orderDetail.orderDataModel = self.orderModel.result.data[indexPath.section];
    [self.navigationController pushViewController:orderDetail animated:YES];
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

    NSMutableArray *tempArray = [NSMutableArray array];
    for (TalkGridModel *c in self.orderfooterView.model.items) {
        [tempArray addObject:c];
    }
    XJOrder *order = [[XJMarket sharedMarket] createOrderWith:tempArray];
    [[XJMarket sharedMarket] buyTradeImmediately:order by:stayle success:^{
        [[ZToastManager ShardInstance] showtoast:@"支付成功"];
        self.tabBarController.selectedIndex = 3;
        self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject];
    }                                     failed:^{
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
