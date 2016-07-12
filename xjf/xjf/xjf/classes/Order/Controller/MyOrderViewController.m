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
#import "XJAccountManager.h"

@interface MyOrderViewController () <UITableViewDelegate, UITableViewDataSource,
        MyOrderFootrtViewDelegate,PayViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderHeaderView *orderheaderView;
@property (nonatomic, strong) MyOrderFooterView *orderfooterView;
@property (nonatomic, assign) PayStyle style;
@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) XJOrder *order;
@end

@implementation MyOrderViewController

static CGFloat payViewH = 285;
static CGFloat tableHeader_NormalH = 35;
static CGFloat tableFooter_NormalH = 45;
static CGFloat tableFooter_orderSucceslH = 100;

static NSString *LessonMyOrderCell_id = @"LessonMyOrderCell_id";
static NSString *TeacherMyOrderCell_id = @"TeacherMyOrderCell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self requestAllOrderData:queryAllOrder method:GET];
}

#pragma mark -requestData

- (void)requestAllOrderData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    if (method == GET) {
        //TalkGridData
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [[ZToastManager ShardInstance] hideprogress];
            __strong typeof(self) sSelf = wSelf;
            sSelf.orderModel = [[OrderModel alloc] initWithData:responseData error:nil];
            [sSelf.tableView reloadData];
        } failedBlock:^(NSError *_Nullable error) {

        }];
    } else if (method == PUT) {
        request.requestParams = self.requestParams.mutableCopy;
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            [self requestAllOrderData:queryAllOrder method:GET];
        } failedBlock:^(NSError *_Nullable error) {

        }];
    }

}


#pragma mark - initMainUI

- (void)initMainUI {
    self.navigationItem.title = @"我的订单";
    [self setTableView];
}

#pragma mark --setTableView--

- (void)setTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.bottom.equalTo(self.view);
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
    if ([orderDataModel.type isEqualToString:@"subscribe"]) {
        return 1;
    }
    return orderDataModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonMyOrderCell_id];
    OrderDataModel *orderDataModel = self.orderModel.result.data[indexPath.section];

    //lessons
    cell.model = orderDataModel.items[indexPath.row];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    
    cell.isMyOrder = YES;
    cell.oldPrice.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.status = orderDataModel.status;
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

    self.orderfooterView.section = section;
    CGFloat temp = 0;
    for (TalkGridModel *model in self.orderfooterView.model.items) {
        temp += model.price.floatValue;
    }

    if ([self.orderfooterView.model.type isEqualToString:@"subscribe"] || self.orderfooterView.model.items.count == 0) {
        //Vip
        self.orderfooterView.orderDescription.text = [NSString stringWithFormat:@"共1件商品 实际付款:￥%.2lf", [self.orderfooterView.model.amount_display floatValue]];

    } else if ([self.orderfooterView.model.type isEqualToString:@"purchase"]) {
        //lessons
        self.orderfooterView.orderDescription.text = [NSString
                stringWithFormat:@"共x%ld件商品 实际付款:￥%.2lf", self.orderfooterView.model.items.count, temp / 100];
    }
    return self.orderfooterView;
}

//OrderFooterViewDelegate
- (void)MyOrderFootrtView:(MyOrderFooterView *)orderFooterView goPayOrCancelOreder:(UIButton *)sender {
    OrderDataModel *model = self.orderModel.result.data[orderFooterView.section];
    if ([sender.titleLabel.text isEqualToString:@"去付款"]) {
        [PayView showWithTarget:self type:PayViewDefault];
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [AlertUtils alertWithTarget:self title:@"提示" content:@"确定取消订单？" confirmBlock:^{
            self.requestParams = @{@"status" : [NSString stringWithFormat:@"2"]};
            [self requestAllOrderData:[NSString stringWithFormat:@"%@%@", cancelOrder, model.id] method:PUT];
        }];
    }
}

-(void)payView:(PayView *)payView DidSelectedBy:(PayStyle)type {
    self.style = type;
}
-(void)payViewDidPaySuccessed:(PayView *)payView {
    [self requestAllOrderData:queryAllOrder method:GET];
    if ([self.orderfooterView.model.type isEqualToString:@"subscribe"] ||
        self.orderfooterView.model.items.count == 0) {
        [[XJAccountManager defaultManager] updateUserInfoCompeletionBlock:nil];
    }
}
-(void)payViewDidPayFailed:(PayView *)payView {
    [[ZToastManager ShardInstance] showtoast:@"支付失败"];
}
-(id)paramsForCurrentpayView:(PayView *)payView {
    if ([self.orderfooterView.model.type isEqualToString:@"subscribe"] ||
        self.orderfooterView.model.items.count == 0) {
        //Vip
        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.orderfooterView.model.membership.type forKey:@"type"];
        [dic setValue:self.orderfooterView.model.membership.period forKey:@"period"];
        [dicData setValue:dic forKey:@"membership"];
        return dicData;
    }else if ([self.orderfooterView.model.type isEqualToString:@"purchase"]) {
        //lessons
        NSMutableArray *tempArray = [NSMutableArray array];
        for (TalkGridModel *c in self.orderfooterView.model.items) {
            [tempArray addObject:c];
        }
        return tempArray;
    }
    return nil;
}
#pragma mark tableViewDidSelected

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetaiViewController *orderDetail = [OrderDetaiViewController new];
    orderDetail.orderDataModel = self.orderModel.result.data[indexPath.section];
    [self.navigationController pushViewController:orderDetail animated:YES];
}
@end
