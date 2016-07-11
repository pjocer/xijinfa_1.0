//
//  RechargeResultController.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PayResultController.h"
#import "UILabel+StringFrame.h"
#import "MyOrderViewController.h"
#import "MyLessonsViewController.h"
@interface PayResultController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *orderCompelete;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backToHomeConstrained;
@property (weak, nonatomic) IBOutlet UILabel *help;
@property (assign, nonatomic) BOOL isSuccess;
@property (assign, nonatomic) BOOL type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@end

@implementation PayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    [self initProperties];
}
- (void)initProperties {
    _statusImageView.highlighted = !_isSuccess;
    _backToHomeConstrained.constant = _isSuccess?80:15;
    _orderCompelete.hidden = !_isSuccess;
    _statusLabel.text = _isSuccess?(_type==RechargeType?@"充值成功":@"支付成功"):(_type==RechargeType?@"充值失败":@"支付失败");
    _help.hidden = _isSuccess;
    [_help changeColorWithString:@"需要帮助请致电 021-50265022 联系客服" light:@"021-50265022" Font:12 Color:BlueColor];
    _headerHeight.constant = _isSuccess?133:162;
}
- (void)initControl {
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToHome)];
    [_back addGestureRecognizer:back];
    UITapGestureRecognizer *order = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compeleteOrder)];
    [_orderCompelete addGestureRecognizer:order];
}
- (void)backToHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)compeleteOrder {
    if (_type == RechargeType) {
        MyOrderViewController *order = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }else {
        MyLessonsViewController *controller = [[MyLessonsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(instancetype)initWithSuccess:(BOOL)isSuccess type:(PayResultType)type{
    self = [super init];
    if (self) {
        _isSuccess = isSuccess;
        _type = type;
    }
    return self;
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
