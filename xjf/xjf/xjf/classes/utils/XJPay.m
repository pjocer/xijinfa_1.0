//
//  XJPay.m
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJPay.h"
#import "XJAccountManager.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "ZPlatformShare.h"


@interface Product : NSObject
/*********************************支付四要素*********************************/

//商户在支付宝签约时，支付宝为商户分配的唯一标识号(以2088开头的16位纯数字)。
@property (nonatomic, copy) NSString *partner;

//卖家支付宝账号对应的支付宝唯一用户号(以2088开头的16位纯数字),订单支付金额将打入该账户,一个partner可以对应多个seller_id。
@property (nonatomic, copy) NSString *sellerID;

//商户网站商品对应的唯一订单号。
@property (nonatomic, copy) NSString *outTradeNO;

//该笔订单的资金总额，单位为RMB(Yuan)。取值范围为[0.01，100000000.00]，精确到小数点后两位。
@property (nonatomic, copy) NSString *totalFee;



/*********************************商品相关*********************************/
//商品的标题/交易标题/订单标题/订单关键字等。
@property (nonatomic, copy) NSString *subject;

//对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
@property (nonatomic, copy) NSString *body;



/*********************************其他必传参数*********************************/

//接口名称，固定为mobile.securitypay.pay。
@property (nonatomic, copy) NSString *service;

//商户网站使用的编码格式，固定为utf-8。
@property (nonatomic, copy) NSString *inputCharset;

//支付宝服务器主动通知商户网站里指定的页面http路径。
@property (nonatomic, copy) NSString *notifyURL;



/*********************************可选参数*********************************/

//支付类型，1：商品购买。(不传情况下的默认值)
@property (nonatomic, copy) NSString *paymentType;

//具体区分本地交易的商品类型,1：实物交易; (不传情况下的默认值),0：虚拟交易; (不允许使用信用卡等规则)。
@property (nonatomic, copy) NSString *goodsType;

//支付时是否发起实名校验,F：不发起实名校验; (不传情况下的默认值),T：发起实名校验;(商户业务需要买家实名认证)
@property (nonatomic, copy) NSString *rnCheck;

//标识客户端。
@property (nonatomic, copy) NSString *appID;

//标识客户端来源。参数值内容约定如下：appenv=“system=客户端平台名^version=业务系统版本”
@property (nonatomic, copy) NSString *appenv;

//设置未付款交易的超时时间，一旦超时，该笔交易就会自动被关闭。当用户输入支付密码、点击确认付款后（即创建支付宝交易后）开始计时。取值范围：1m～15d，或者使用绝对时间（示例格式：2014-06-13 16:00:00）。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。该参数数值不接受小数点，如1.5h，可转换为90m。
@property (nonatomic, copy) NSString *itBPay;

//商品地址
@property (nonatomic, copy) NSString *showURL;

//业务扩展参数，支付宝特定的业务需要添加该字段，json格式。 商户接入时和支付宝协商确定。
@property (nonatomic, strong) NSMutableDictionary *outContext;
@end

@implementation Product
- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.sellerID) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.sellerID];
    }
    if (self.outTradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.outTradeNO];
    }
    if (self.subject) {
        [discription appendFormat:@"&subject=\"%@\"", self.subject];
    }
    
    if (self.body) {
        [discription appendFormat:@"&body=\"%@\"", self.body];
    }
    if (self.totalFee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.totalFee];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showURL) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showURL];//m.alipay.com
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.outContext allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.outContext objectForKey:key]];
    }
    return discription;
}
@end

@interface XJPay ()
@property (nonatomic, strong) Payment *payment_alipay;
@property (nonatomic, strong) Payment *payment_wechat;
@property (nonatomic, strong) Order *order;
@end

@implementation XJPay

- (Order *)getCurrentOrder {
    return _order;
}

-(void)buyTradeImmediately:(NSArray<NSString *> *)trade_id by:(PayStyle)style success:(dispatch_block_t)success failed:(dispatch_block_t)failed {
    self.success = success;
    self.failed = failed;
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:buy_trade RequestMethod:POST];
    NSString *access_token = [[XJAccountManager defaultManager] accessToken];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",access_token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trade_id,@"items", nil];
    request.requestParams = params;
    @weakify(self)
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        @strongify(self)
        if ([self handleData:responseData]) {
            [self produceOrder:style];
        }else {
            if (self.failed) self.failed();
        }
    } failedBlock:^(NSError * _Nullable error) {
        if (self.failed) self.failed();
    }];
}

- (void)produceOrder:(PayStyle)style {
    if (style == Alipay) {
        [[AlipaySDK defaultService] payOrder:self.payment_alipay.data fromScheme:@"com.yiban.iphone.mainApp" callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                if (self.success) self.success();
            } else {
                NSLog(@"%@",resultDic[@"memo"]);
                if (self.failed) self.failed();
            }
        }];
    }else {
        [[ZPlatformShare sharedInstance] weiChatPay:self.payment_wechat.data success:self.success failed:self.failed];
    }
}

- (BOOL)handleData:(NSData *)data {
    self.order = [[Order alloc]initWithData:data error:nil];
    NSMutableArray *payments = self.order.result.payment;
    if (payments) {
        if (payments) {
            for (Payment *payment in payments) {
                if ([payment.channel isEqualToString:@"alipay"]) {
                    self.payment_alipay = payment;
                }else {
                    self.payment_wechat = payment;
                }
            }
        }
        return YES;
    }
    return NO;
}

@end
