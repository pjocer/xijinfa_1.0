
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

@interface XJMarket ()
@property (nonatomic, strong) NSMutableDictionary *shopping_cart;
@property (nonatomic, strong) NSMutableDictionary *my_lessons;
@property (nonatomic, strong) NSMutableArray *shopping_class;
@property (nonatomic, strong) NSMutableArray *shopping_training;
@property (nonatomic, strong) NSMutableArray *my_lessons_class;
@property (nonatomic, strong) NSMutableArray *my_lessons_training;
@end

@implementation XJMarket

+(instancetype)sharedMarket {
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
    _my_lessons = [NSMutableDictionary dictionaryWithObjectsAndKeys:_my_lessons_class,MY_LESSONS_XUETANG,_my_lessons_training,MY_LESSONS_PEIXUN, nil];
    _shopping_cart = [NSMutableDictionary dictionaryWithObjectsAndKeys:_shopping_class,XJ_XUETANG_SHOP,_shopping_training,XJ_CONGYE_PEIXUN_SHOP, nil];
    [self createFileAtPath:[self pathForShoppingCart]];
    [_shopping_cart writeToFile:[self pathForShoppingCart] atomically:YES];
    [self createFileAtPath:[self pathForMyLessons]];
    [_my_lessons writeToFile:[self pathForMyLessons] atomically:YES];
}

-(XJOrder *)createOrderWith:(NSArray<TalkGridModel *> *)goods {
    return [[XJOrder alloc] initWith:goods];
}

- (void)buyTradeImmediately:(nonnull XJOrder *)order by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed {
    XJPay *pay = [[XJPay alloc]init];
    NSMutableArray *trades = [NSMutableArray array];
    for (TalkGridModel *model in order.goods) {
        [trades addObject:model.id_];
    }
    [pay buyTradeImmediately:trades by:style success:success failed:failed];
    ReceivedNotification(self, PayLessonsSuccess, ^(NSNotification *notification) {
        if (success) success();
    });
}

-(BOOL)isAlreadyExists:(TalkGridModel *)goods key:(NSString *)key {
    if ([key isEqualToString:XJ_XUETANG_SHOP] || [key isEqualToString:XJ_CONGYE_PEIXUN_SHOP]) {
        NSArray *classes = [self shoppingCartFor:key];
        for (TalkGridModel *good in classes) {
            if ([good.id_ isEqualToString:goods.id_]) {
                return YES;
            }else {
                return NO;
            }
        }
    }else if ([key isEqualToString:MY_LESSONS_PEIXUN] || [key isEqualToString:MY_LESSONS_XUETANG]) {
        NSArray *classes = [self myLessonsFor:key];
        for (TalkGridModel *good in classes) {
            if ([good.id_ isEqualToString:goods.id_]) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

-(void)deleteGoodsFrom:(NSString *)key goods:(NSArray<TalkGridModel *> *)goods {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self shoppingCartFor:key]];
    for (int i = 0; i < goods.count; i++) {
        TalkGridModel *good = goods[i];
        for (TalkGridModel *model in goodsList) {
            if ([good.id_ isEqualToString:model.id_]) {
                [goodsList removeObject:model];
                break;
            }
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodsList forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
}

-(void)deleteLessons:(NSArray<TalkGridModel *> *)lessons key:(NSString *)key {
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
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodsList forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
}

- (void)addLessons:(NSArray <TalkGridModel*>*)lessons key:(NSString *)key {
    NSMutableArray *classes = [NSMutableArray arrayWithArray:[self myLessonsFor:key]];
    for (TalkGridModel *model in lessons) {
        NSDictionary *dic = [model toDictionary];
        [classes addObject:dic];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForMyLessons]] mutableCopy];
    [dic setObject:classes forKey:key];
    [dic writeToFile:[self pathForMyLessons] atomically:YES];
}

- (void)addGoods:(NSArray <TalkGridModel*>*)goods key:(NSString *)key {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self shoppingCartFor:key]];
    for (TalkGridModel *model in goods) {
        NSDictionary *dic = [model toDictionary];
        [goodsList addObject:dic];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodsList forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
}
-(NSArray<TalkGridModel *> *)myLessonsFor:(NSString *)key {
    NSString *path = [self pathForMyLessons];
    NSDictionary *lessons = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [lessons objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
}
-(NSArray<TalkGridModel *> *)shoppingCartFor:(NSString *)key {
    NSString *path = [self pathForShoppingCart];
    NSDictionary *shoppcart = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [shoppcart objectForKey:key]) {
        TalkGridModel *model = [[TalkGridModel alloc] initWithDictionary:dic error:nil];
        [array addObject:model];
    }
    return array;
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
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] createFileAtPath:[self pathForMyLessons] contents:nil attributes:nil];
    }
    return YES;
}

@end
