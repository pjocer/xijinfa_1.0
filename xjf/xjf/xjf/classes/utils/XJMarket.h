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
#define XJ_XUETANG_SHOP @"xijin_xuetang"
//获取购物车从业培训内容
#define XJ_CONGYE_PEIXUN_SHOP @"xijin_congye_peixun"
//获取我的课程析金学堂内容
#define MY_LESSONS_XUETANG @"my_lessons_xuetang"
//获取我的课程从业培训内容
#define MY_LESSONS_PEIXUN @"my_lessons_peixun"

typedef enum : NSUInteger {
    Alipay,
    WechatPay,
} PayStyle;

@interface XJMarket : NSObject

+ (nonnull instancetype)sharedMarket;

-(nonnull instancetype)init NS_UNAVAILABLE;

- (nonnull XJOrder *)createVipOrderWith:(nonnull NSDictionary *)params;

- (nonnull XJOrder *)createOrderWith:(nullable NSArray <TalkGridModel *>*)goods;

- (void)buyTradeImmediately:(nonnull XJOrder *)order by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed;

- (nullable NSArray <TalkGridModel*>*)shoppingCartFor:(nullable NSString *)key;

- (nullable NSMutableArray <TalkGridModel*>*)myLessonsFor:(nullable NSString *)key;

- (nullable NSMutableArray <NSString *>*)recentlyUsedLabels;

- (nullable NSMutableArray <NSString *>*)recentlySearched;

- (void)addSearch:(nonnull NSString *)search;

- (void)addLabels:(nonnull NSString *)label;

- (void)addLessons:(nullable NSArray <TalkGridModel*>*)lessons key:(nonnull NSString *)key;

- (void)addGoods:(nullable NSArray <TalkGridModel*>*)goods key:(nonnull NSString *)key;

- (void)deleteGoodsFrom:(nonnull NSString *)key goods:(nonnull NSArray<TalkGridModel *> *)goods;

- (void)deleteLessons:(nonnull NSArray<TalkGridModel *> *)lessons key:(nonnull NSString *)key;

-  (void)clearRecentlySearched;

- (BOOL)isAlreadyExists:(nonnull TalkGridModel *)goods key:(nonnull NSString *)key;

@end
