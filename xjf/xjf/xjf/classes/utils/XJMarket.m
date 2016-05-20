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
    return self;
}
- (void)buyTradeImmediately:(nonnull TalkGridModel *)trade_model by:(PayStyle)style success:(nullable dispatch_block_t)success failed:(nullable dispatch_block_t)failed {
    XJPay *pay = [[XJPay alloc]init];
    [pay buyTradeImmediately:trade_model.id_ by:style success:^{
        NSLog(@"支付成功 type:1");
    } failed:^{
        NSLog(@"支付失败 type:1");
    }];
    ReceivedNotification(self, PayLessonsSuccess, ^(NSNotification *notification) {
        if ([trade_model.department isEqualToString:@"dept3"]) {
            [self addLessons:@[trade_model] key:MY_LESSONS_XUETANG];
        }else {
            [self addLessons:@[trade_model] key:MY_LESSONS_PEIXUN];
        }
        UIViewController *controller = getCurrentDisplayController();
        MyLessonsViewController *lesson = [[MyLessonsViewController alloc]init];
        [controller.navigationController pushViewController:lesson animated:YES];
    });
}

- (void)addLessons:(NSArray <TalkGridModel*>*)lessons key:(NSString *)key {
    NSMutableArray *classes = [NSMutableArray arrayWithArray:[self myLessonsFor:key]];
    [classes addObjectsFromArray:lessons];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForMyLessons]] mutableCopy];
    [dic setObject:classes forKey:key];
    [dic writeToFile:[self pathForMyLessons] atomically:YES];
}

- (void)addGoods:(NSArray <TalkGridModel*>*)goods key:(NSString *)key {
    NSMutableArray *goodsList = [NSMutableArray arrayWithArray:[self shoppingCartFor:key]];
    [goodsList addObjectsFromArray:goods];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathForShoppingCart]] mutableCopy];
    [dic setObject:goodsList forKey:key];
    [dic writeToFile:[self pathForShoppingCart] atomically:YES];
}

-(NSArray *)myLessonsFor:(NSString *)key {
    NSString *path = [self pathForMyLessons];
    NSDictionary *lessons = [NSDictionary dictionaryWithContentsOfFile:path];
    return [lessons objectForKey:key];
}

-(NSArray *)shoppingCartFor:(NSString *)key {
    NSString *path = [self pathForShoppingCart];
    NSDictionary *shoppcart = [NSDictionary dictionaryWithContentsOfFile:path];
    return [shoppcart objectForKey:key];
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
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    return [fileManeger createFileAtPath:path contents:nil attributes:nil];
}

@end
