//
//  XJMarket.m
//  xjf
//
//  Created by PerryJ on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJMarket.h"
#import "XJPay.h"
#import "XJAccountManager.h"
#import "MyLessonsViewController.h"
#import "StringUtil.h"
#import "XJFCacheHandler.h"

#import "XJMarket.h"
#import "XJAccountManager.h"
#import "ShoppingCartViewController.h"

NSString * XJ_XUETANG_SHOP = @"XJ_XUETANG_SHOP";
NSString * XJ_CONGYE_PEIXUN_SHOP = @"XJ_CONGYE_PEIXUN_SHOP";
NSString * MY_LESSONS_XUETANG = @"MY_LESSONS_XUETANG";
NSString * MY_LESSONS_PEIXUN = @"MY_LESSONS_PEIXUN";

@interface XJMarket ()
@property (nonatomic, strong) XJOrder *currentOrder;
@end

@implementation XJMarket

+ (instancetype)sharedMarket {
    static XJMarket *market = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        market = [[XJMarket alloc] _init];
    });
    return market;
}

- (instancetype)_init {
    self = [super init];
    if (self) {
        //initialize
    }
    return self;
}
-(void)createRechargeOrderWith:(NSDictionary *)params success:(XJMarkedBlock)success failed:(XJMarkedBlock)failed {
    _currentOrder = [[XJOrder alloc] initWithParams:params success:^{
        if (success) success (_currentOrder);
    } failed:^{
        if (failed) failed (_currentOrder);
    }];
}
-(void)createOrderWith:(NSArray<TalkGridModel *> *)goods success:(XJMarkedBlock)success failed:(XJMarkedBlock)failed {
    _currentOrder = [[XJOrder alloc] initWith:goods success:^{
        if (success) success (_currentOrder);
    } failed:^{
        if (failed) failed (_currentOrder);
    }];
}
- (void)buyTradeImmediately:(nonnull XJOrder *)order by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed {
    NSParameterAssert(order);
    XJPay *pay = [[XJPay alloc] init];
    [pay buyTradeImmediately:order by:style success:success failed:failed];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:PayLessonsResult object:nil] subscribeNext:^(NSNotification *notification) {
        NSNumber *num = notification.object;
        if (num.boolValue) {
            [[XJAccountManager defaultManager] updateUserInfoCompeletionBlock:^(UserProfileModel *model) {
                if (success) success();
            }];
        }else {
            if (failed) failed();
        }
    }];
}

- (BOOL)isAlreadyExists:(TalkGridModel *)goods key:(NSString *)key {
    if ([key isEqualToString:XJ_XUETANG_SHOP] || [key isEqualToString:XJ_CONGYE_PEIXUN_SHOP]) {
        NSArray *classes = [self shoppingCartFor:key];
        for (TalkGridModel *good in classes) {
            if ([good.id_ isEqualToString:goods.id_]) {
                return YES;
            }
        }
    } else if ([key isEqualToString:MY_LESSONS_PEIXUN] || [key isEqualToString:MY_LESSONS_XUETANG]) {
        NSArray *classes = [self myLessonsFor:key];
        for (TalkGridModel *good in classes) {
            if ([good.id_ isEqualToString:goods.id_]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)deleteGoodsFrom:(NSString *)key goods:(NSArray<TalkGridModel *> *)goods {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self shoppingCartFor:key]];
    NSMutableArray *array = [goodsList mutableCopy];
    for (int i = 0; i < goods.count; i++) {
        TalkGridModel *good = goods[i];
        for (TalkGridModel *model in goodsList) {
            if ([good.id_ isEqualToString:model.id_]) {
                [array removeObject:model];
                break;
            }
        }
    }
    NSMutableArray *goodlist = [NSMutableArray array];
    for (TalkGridModel *model in array) {
        [goodlist addObject:[model toDictionary]];
    }
    NSString *path = [[XJFCacheHandler sharedInstance] pathFor:SHOPPINGCART_FILE];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:path] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:path atomically:YES];
}

- (void)deleteLessons:(NSArray<TalkGridModel *> *)lessons key:(NSString *)key {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self myLessonsFor:key]];
    for (int i = 0; i < lessons.count; i++) {
        TalkGridModel *good = lessons[i];
        for (TalkGridModel *model in goodsList) {
            if ([good.id_ isEqualToString:model.id_]) {
                [goodsList removeObject:model];
                break;
            }
        }
    }
    NSMutableArray *goodlist = [NSMutableArray array];
    for (TalkGridModel *model in goodsList) {
        [goodlist addObject:[model toDictionary]];
    }
    NSString *path = [[XJFCacheHandler sharedInstance] pathFor:SHOPPINGCART_FILE];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:path] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:path atomically:YES];
}

- (void)addLessons:(NSArray <TalkGridModel *> *)lessons key:(NSString *)key {
    NSMutableArray *classes = [NSMutableArray arrayWithArray:[self myLessonsFor:key]];
    NSMutableArray *class = [NSMutableArray new];
    for (TalkGridModel *model in classes) {
        [class addObject:[model toDictionary]];
    }
    for (TalkGridModel *model in lessons) {
        NSDictionary *dic = [model toDictionary];
        [class addObject:dic];
    }
    NSString *PATH = [[XJFCacheHandler sharedInstance] pathFor:USERLESSONS_FILE];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:PATH] mutableCopy];
    [dic setObject:class forKey:key];
    [dic writeToFile:PATH atomically:YES];
}

- (void)addGoods:(NSArray <TalkGridModel *> *)goods key:(NSString *)key {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self shoppingCartFor:key]];
    NSMutableArray *goodlist = [NSMutableArray new];
    for (TalkGridModel *model in goodsList) {
        NSDictionary *dic = [model toDictionary];
        [goodlist addObject:dic];
    }
    for (TalkGridModel *model in goods) {
        NSDictionary *dic = [model toDictionary];
        [goodlist addObject:dic];
    }
    NSString *path = [[XJFCacheHandler sharedInstance] pathFor:SHOPPINGCART_FILE];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:path] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:path atomically:YES];
}

- (NSMutableArray<TalkGridModel *> *)myLessonsFor:(NSString *)key {
    NSString *path = [[XJFCacheHandler sharedInstance] pathFor:USERLESSONS_FILE];
    NSDictionary *lessons = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [lessons objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
}

- (NSArray<TalkGridModel *> *)shoppingCartFor:(NSString *)key {
    NSString *path = [[XJFCacheHandler sharedInstance] pathFor:SHOPPINGCART_FILE];
    NSDictionary *shoppcart = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [shoppcart objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
}


#pragma mark - addCard

- (void)addShoppingCardByModel:(TalkGridModel *)model{
    NSParameterAssert(model);
    NSAssert((model), @"Model cant be nil :%@",model);
    
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
        [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [[ZToastManager ShardInstance] showtoast:@"只有登录后才可以购买"];
    } else {
        
        if ([[XJMarket sharedMarket] isAlreadyExists:model key:XJ_XUETANG_SHOP] || [[XJMarket sharedMarket] isAlreadyExists:model key:XJ_CONGYE_PEIXUN_SHOP]) {
            [[ZToastManager ShardInstance] showtoast:@"课程不能重复购买"];
        } else {
            if ([model.department isEqualToString:@"dept3"]) {
                [[XJMarket sharedMarket] addGoods:@[model] key:XJ_XUETANG_SHOP];
                UIViewController *currentViewController = getCurrentDisplayController();
                [AlertUtils alertWithTarget:currentViewController title:@"已加入购物车" okTitle:@"去结算" cancelButtonTitle:@"再看看" okBlock:^{
                    [currentViewController.navigationController pushViewController:[ShoppingCartViewController new] animated:YES];
                }];
            } else if ([model.department isEqualToString:@"dept4"]) {
                [[XJMarket sharedMarket] addGoods:@[model] key:XJ_CONGYE_PEIXUN_SHOP];
                UIViewController *currentViewController = getCurrentDisplayController();
                [AlertUtils alertWithTarget:currentViewController title:@"已加入购物车" okTitle:@"去结算" cancelButtonTitle:@"再看看" okBlock:^{
                    [currentViewController.navigationController pushViewController:[ShoppingCartViewController new] animated:YES];
                }];
            }
        }
    }
    
    

}

@end
