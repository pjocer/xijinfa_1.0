//
//  XJMarket.h
//  xjf
//
//  Created by PerryJ on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkGridModel.h"
#import "XJOrder.h"

//获取购物车析金学堂内容
FOUNDATION_EXPORT   NSString * _Nonnull XJ_XUETANG_SHOP;
//获取购物车从业培训内容
FOUNDATION_EXPORT   NSString * _Nonnull XJ_CONGYE_PEIXUN_SHOP;
//获取我的课程析金学堂内容
FOUNDATION_EXPORT   NSString * _Nonnull MY_LESSONS_XUETANG;
//获取我的课程从业培训内容
FOUNDATION_EXPORT   NSString * _Nonnull MY_LESSONS_PEIXUN;

typedef enum : NSUInteger {
    Alipay,
    WechatPay,
    UnKnown
} PayStyle;

@interface XJMarket : NSObject

+ (nonnull instancetype)sharedMarket;

- (nonnull instancetype)init NS_UNAVAILABLE;
/**
 *  Create Recharge Order
 *
 *  @param params   Recharge Param
 *  @param delegate Target Need Follow OrderInfoDidChangedDelegate Protocol & Can't be nil
 *
 *  @return XJOrder Instance
 */
- (nonnull XJOrder *)createRechargeOrderWith:(nonnull NSDictionary *)params target:(nonnull id <OrderInfoDidChangedDelegate>)delegate;
/**
 *  Create Order About Trades
 *
 *  @param goods    An Array Only Contained TalkGridModel
 *  @param delegate Target Need Follow OrderInfoDidChangedDelegate Protocol & Can't be nil
 *
 *  @return XJOrder Instance
 */
- (nonnull XJOrder *)createOrderWith:(nullable NSArray <TalkGridModel *> *)goods target:(nonnull id <OrderInfoDidChangedDelegate>)delegate;
/**
 *  Buy Trades Immediately
 *
 *  @param order   An Order Which Need To Purchase
 *  @param style   PayStyle
 *  @param success Call Back When User Purchase Success
 *  @param failed  Call Back When User Purchase Failed
 */
- (void)buyTradeImmediately:(nonnull XJOrder *)order by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed;
/**
 *  Shopping Cart
 *
 *  @param key XJ_XUETANG_SHOP Or XJ_CONGYE_PEIXUN_SHOP
 *
 *  @return An Array Contained TalkGridModel
 */
- (nullable NSArray <TalkGridModel *> *)shoppingCartFor:(nullable NSString *)key;
/**
 *  My Lessons Purchased
 *
 *  @param key MY_LESSONS_XUETANG Or MY_LESSONS_PEIXUN
 *
 *  @return An Array Contained TalkGridModel
 */
- (nullable NSMutableArray <TalkGridModel *> *)myLessonsFor:(nullable NSString *)key;
/**
 *  Add Lessons When User Purchase Successed
 *
 *  @param lessons Lessons
 *  @param key     MY_LESSONS_XUETANG Or MY_LESSONS_PEIXUN
 */
- (void)addLessons:(nullable NSArray <TalkGridModel *> *)lessons key:(nonnull NSString *)key;

- (void)addGoods:(nullable NSArray <TalkGridModel *> *)goods key:(nonnull NSString *)key;

- (void)deleteGoodsFrom:(nonnull NSString *)key goods:(nonnull NSArray<TalkGridModel *> *)goods;

- (void)deleteLessons:(nonnull NSArray<TalkGridModel *> *)lessons key:(nonnull NSString *)key;
/**
 *  Determine Whether already exists
 *
 *  @param goods Which need judge
 *  @param key
 *
 *  @return Return YES if good is already exists
 */
- (BOOL)isAlreadyExists:(nonnull TalkGridModel *)goods key:(nonnull NSString *)key;

@end
