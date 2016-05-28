//
//  OrderDetaiViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderDetaiViewController.h"
#import "PayView.h"
#import "XJMarket.h"
#import "VideoListCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"

@interface OrderDetaiViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *cancel;
@property(nonatomic, strong) UIButton *nowPay;
@property(nonatomic, strong) PayView *payView;
@property(nonatomic, strong) UIView *payingBackGroudView;
@property(nonatomic, strong) OrderHeaderView *orderheaderView;
@property(nonatomic, strong) OrderFooterView *orderfooterView;
@property(nonatomic, assign) BOOL isOrderCancel;
@property(nonatomic, assign) BOOL isOrderSucces;
@end

@implementation OrderDetaiViewController
static CGFloat BottomPayButtonH = 50;
static CGFloat payViewH = 285;
static CGFloat tableHeader_NormalH = 35;
static CGFloat tableFooter_NormalH = 45;
static CGFloat tableFooter_orderSucceslH = 80;

static NSString *LessonOrderCell_id = @"LessonOrderCell_id";
static NSString *TeacherOrderCell_id = @"TeacherOrderCell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.isOrderCancel = NO;
    self.isOrderSucces = NO;
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

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:LessonOrderCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonOrderCell_id];
    //    cell.model = self.dataSource[indexPath.row];
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
    if (_isOrderSucces) {
        return tableFooter_orderSucceslH;
    }
    return tableFooter_NormalH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.orderheaderView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
    return self.orderheaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.orderfooterView = [[OrderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 0)];
    self.orderfooterView.isPaySucces = _isOrderSucces;
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
    if (!_isOrderSucces) {
        self.nowPay.hidden = YES;
        self.cancel.hidden = YES;
        self.orderfooterView.orderDescription.hidden = YES;
        self.orderfooterView.orderStatus.text = @"订单已取消";
        _isOrderCancel = YES;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_isOrderCancel == YES) {
        self.orderfooterView.orderDescription.hidden = YES;
        self.orderfooterView.orderStatus.text = @"订单已取消";
    }
    if (_isOrderSucces == YES) {
        self.orderfooterView.orderStatus.text = @"订单已成功";
    }

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
//    [[ZToastManager ShardInstance] showprogress];
//    [[XJMarket sharedMarket] buyTradeImmediately:self.model by:stayle success:^{
//        [[ZToastManager ShardInstance] hideprogress];
//        if ([self.model.department isEqualToString:@"dept3"]) {
//            [[XJMarket sharedMarket] addLessons:@[self.model] key:MY_LESSONS_XUETANG];
//        } else {
//            [[XJMarket sharedMarket] addLessons:@[self.model] key:MY_LESSONS_PEIXUN];
//        }
//        MyLessonsViewController *lesson = [[MyLessonsViewController alloc] init];
//        [self.navigationController pushViewController:lesson animated:YES];
//    }                                     failed:^{
//        [[ZToastManager ShardInstance] hideprogress];
//        [[ZToastManager ShardInstance] showtoast:@"支付失败"];
//    }];
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

    self.isOrderSucces = YES;
    self.nowPay.hidden = YES;
    self.cancel.hidden = YES;
    self.orderfooterView.orderStatus.text = @"订单已成功";
    [self.tableView reloadData];
}


@end
