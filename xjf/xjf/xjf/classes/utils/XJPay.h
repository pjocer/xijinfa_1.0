//
//  XJPay.h
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Alipay,
    WechatPay,
} PayStyle;

@interface XJPay : NSObject

+ (instancetype)defaultPay;

- (instancetype)init NS_UNAVAILABLE;

- (void)buyTradeImmediately:(nonnull NSString *)trade_id by:(PayStyle)style;

@end
