//
//  XJOrder.h
//  xjf
//
//  Created by PerryJ on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkGridModel.h"
#import "Order.h"
@class XJOrder;
typedef void(^XJMarkedBlock)(XJOrder  *order);

typedef NS_OPTIONS(NSUInteger, OrderStatus) {
    OrderStatusSuccess,
    OrderStatusCancel,
    OrderStatusUndetermined
} NS_ENUM_AVAILABLE_IOS(8_0);

@interface XJOrder : NSObject

@property (nonatomic, assign) OrderStatus status;

@property (nonatomic, strong) NSMutableArray <TalkGridModel *> *goods;

@property (nonatomic, strong) Order *order;

- (instancetype)initWith:(NSArray <TalkGridModel *> *)goods success:(dispatch_block_t)success failed:(dispatch_block_t)failed;

- (instancetype)initWithParams:(NSDictionary *)params success:(dispatch_block_t)success failed:(dispatch_block_t)failed;

- (NSArray <TalkGridModel *> *)getClassGoods;

- (NSArray <TalkGridModel *> *)getTrainGoods;

- (void)orderCancel;

@end
