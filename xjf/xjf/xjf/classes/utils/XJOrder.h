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
typedef NS_OPTIONS(NSUInteger, OrderStatus) {
    OrderStatusSuccess,
    OrderStatusCancel,
    OrderStatusUndetermined
} NS_ENUM_AVAILABLE_IOS(8_0);

@protocol OrderInfoDidChangedDelegate <NSObject>
- (void)orderInfoDidChanged:(Order *)order;
@end

@interface XJOrder : NSObject

@property (nonatomic, weak) id <OrderInfoDidChangedDelegate>delegate;

@property (nonatomic, assign) OrderStatus status;

@property (nonatomic, strong) NSMutableArray <TalkGridModel *>*goods;

@property (nonatomic, strong) Order *order;

- (instancetype)initWith:(NSArray <TalkGridModel *> *)goods;

- (NSArray <TalkGridModel *>*)getClassGoods;

- (NSArray <TalkGridModel *>*)getTrainGoods;

- (void)orderCancel;

@end
