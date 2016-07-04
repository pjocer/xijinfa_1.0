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

@interface XJMarket ()
@property (nonatomic, strong) NSMutableDictionary *shopping_cart;
@property (nonatomic, strong) NSMutableDictionary *my_lessons;
@property (nonatomic, strong) NSMutableArray *shopping_class;
@property (nonatomic, strong) NSMutableArray *shopping_training;
@property (nonatomic, strong) NSMutableArray *my_lessons_class;
@property (nonatomic, strong) NSMutableArray *my_lessons_training;
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
        [self createPlistFile];
    }
    return self;
}

- (void)createPlistFile {
    _shopping_class = [NSMutableArray array];
    _shopping_training = [NSMutableArray array];
    _my_lessons_class = [NSMutableArray array];
    _my_lessons_training = [NSMutableArray array];
    _my_lessons = [NSMutableDictionary dictionaryWithObjectsAndKeys:_my_lessons_class, MY_LESSONS_XUETANG, _my_lessons_training, MY_LESSONS_PEIXUN, nil];
    _shopping_cart = [NSMutableDictionary dictionaryWithObjectsAndKeys:_shopping_class, XJ_XUETANG_SHOP, _shopping_training, XJ_CONGYE_PEIXUN_SHOP, nil];
    [self createFileAtPath:[self pathForShoppingCart]];
    [_shopping_cart writeToFile:[self pathForShoppingCart] atomically:YES];
    [self createFileAtPath:[self pathForMyLessons]];
    [_my_lessons writeToFile:[self pathForMyLessons] atomically:YES];
    [self createFileAtPath:[self pathForLabels]];
    [self createFileAtPath:[self pathForSearched]];
    NSMutableArray *array = [NSMutableArray array];
    [array writeToFile:[self pathForLabels] atomically:YES];
    [array writeToFile:[self pathForSearched] atomically:YES];
}

- (XJOrder *)createVipOrderWith:(NSDictionary *)params target:(nonnull id <OrderInfoDidChangedDelegate>)delegate {
    XJOrder *order = [[XJOrder alloc] initWithParams:params];
    order.delegate = delegate;
    return order;
}

- (XJOrder *)createOrderWith:(NSArray<TalkGridModel *> *)goods target:(nonnull id <OrderInfoDidChangedDelegate>)delegate {
    XJOrder *order = [[XJOrder alloc] initWith:goods];
    order.delegate = delegate;
    return order;
}

- (void)buyTradeImmediately:(nonnull XJOrder *)order by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed {
    XJPay *pay = [[XJPay alloc] init];
    [pay buyTradeImmediately:order.order.result.payment by:style success:success failed:failed];
    ReceivedNotification(self, PayLessonsResult, ^(NSNotification *notification) {
        NSNumber *num = notification.object;
        if (num.boolValue) {
            if (success) success();
        }else {
            if (failed) failed();
        }
    });
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

- (void)clearRecentlySearched {
    NSArray *array = [NSArray array];
    [array writeToFile:[self pathForSearched] atomically:YES];
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
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
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
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
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
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForMyLessons]] mutableCopy];
    [dic setObject:class forKey:key];
    [dic writeToFile:[self pathForMyLessons] atomically:YES];
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
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodlist forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
}

- (void)addSearch:(NSString *)search {
    NSMutableArray *array = [[NSMutableArray arrayWithContentsOfFile:[self pathForSearched]] mutableCopy];
    if (![array containsObject:search]) {
        [array insertObject:search atIndex:0];
        if (array.count > 10) {
            [array removeLastObject];
        }
        [array writeToFile:[self pathForSearched] atomically:YES];
    }
}

- (void)addLabels:(NSString *)label {
    NSMutableArray *array = [[NSMutableArray arrayWithContentsOfFile:[self pathForLabels]] mutableCopy];
    if (![array containsObject:label]) {
        [array insertObject:label atIndex:0];
        if (array.count > 10) {
            [array removeObjectAtIndex:10];
        }
        [array writeToFile:[self pathForLabels] atomically:YES];
    }
}

- (NSMutableArray<NSString *> *)recentlyUsedLabels {
    return [NSMutableArray arrayWithContentsOfFile:[self pathForLabels]];
}

- (NSMutableArray<NSString *> *)recentlySearched {
    return [NSMutableArray arrayWithContentsOfFile:[self pathForSearched]];
}

- (NSMutableArray<TalkGridModel *> *)myLessonsFor:(NSString *)key {
    NSString *path = [self pathForMyLessons];
    NSDictionary *lessons = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [lessons objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
}

- (NSArray<TalkGridModel *> *)shoppingCartFor:(NSString *)key {
    NSString *path = [self pathForShoppingCart];
    NSDictionary *shoppcart = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [shoppcart objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
}

- (NSString *)pathForSearched {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *searchPath = [path stringByAppendingPathComponent:@"search.plist"];
    return searchPath;
}

- (NSString *)pathForLabels {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *labelPath = [path stringByAppendingPathComponent:@"label.plist"];
    return labelPath;
}

- (NSString *)pathForShoppingCart {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *lessonPath = [path stringByAppendingPathComponent:@"shopping_cart.plist"];
    return lessonPath;
}

- (NSString *)pathForMyLessons {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *lessonPath = [path stringByAppendingPathComponent:@"user_lessons.plist"];
    return lessonPath;
}

- (BOOL)createFileAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
}

@end
