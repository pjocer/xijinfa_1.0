//
//  XJMarket.h
//  xjf
//
//  Created by PerryJ on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkGridModel.h"

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

- (void)buyTradeImmediately:(nonnull TalkGridModel *)trade_model by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed;

- (nullable NSArray <TalkGridModel*>*)shoppingCartFor:(nullable NSString *)key;

- (nullable NSArray <TalkGridModel*>*)myLessonsFor:(nullable NSString *)key;

- (nullable NSString *)pathForShoppingCart;

- (nullable NSString *)pathForMyLessons;

- (BOOL)createFileAtPath:(nullable NSString *)path;

- (void)addLessons:(nullable NSArray <TalkGridModel*>*)lessons key:(nullable NSString *)key;
@end
