//
//  XJPay.h
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJMarket.h"

@class Order;

@interface XJPay : NSObject

@property (nonatomic, copy, nullable) dispatch_block_t success;

@property (nonatomic, copy, nullable) dispatch_block_t failed;

- (void)buyTradeImmediately:(nonnull NSArray <Payment *> *)payment by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed;
@end
