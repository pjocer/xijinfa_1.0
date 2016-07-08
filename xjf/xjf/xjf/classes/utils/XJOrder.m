//
//  XJOrder.m
//  xjf
//
//  Created by PerryJ on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJOrder.h"
#import "XJAccountManager.h"
#import "ZToastManager.h"

@interface XJOrder () {
    dispatch_block_t _success;
    dispatch_block_t _failed;
}
@property (nonatomic, strong) NSMutableArray *trades;
@end

@implementation XJOrder
-(instancetype)initWith:(NSArray<TalkGridModel *> *)goods success:(dispatch_block_t)success failed:(dispatch_block_t)failed {
    self = [super init];
    if (self) {
        _goods = [NSMutableArray array];
        _trades = [NSMutableArray array];
        _success = success;
        _failed = failed;
        for (TalkGridModel *model in goods) {
            [_goods addObject:model];
            [_trades addObject:model.id_];
        }
        [self initOrder];
    }
    return self;
}
-(instancetype)initWithParams:(NSDictionary *)params success:(dispatch_block_t)success failed:(dispatch_block_t)failed {
    self = [super init];
    if (self) {
        _success = success;
        _failed = failed;
        [self initRechargeOrder:params];
    }
    return self;
}

- (void)initRechargeOrder:(NSDictionary *)params {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:buy_trade RequestMethod:POST];
    NSString *access_token = [[XJAccountManager defaultManager] accessToken];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", access_token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:params];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.order = [[Order alloc] initWithData:responseData error:nil];
        if (self.order.errCode.integerValue == 0) {
            if (_success) _success();
        } else {
            [[ZToastManager ShardInstance] showtoast:@"生成订单失败"];
            if (_failed) _failed();
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"生成订单失败"];
        if (_failed) _failed();
    }];
}

- (void)initOrder {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:buy_trade RequestMethod:POST];
    NSString *access_token = [[XJAccountManager defaultManager] accessToken];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", access_token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"items" : _trades}];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.order = [[Order alloc] initWithData:responseData error:nil];
        if (self.order.errCode.integerValue == 0) {
            if (_success) _success();
        } else {
            [[ZToastManager ShardInstance] showtoast:@"生成订单失败"];
            if (_failed) _failed();
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"生成订单失败"];
        if (_failed) _failed();
    }];
}

- (void)orderCancel {
    self.goods = nil;
}

- (NSArray<TalkGridModel *> *)getClassGoods {
    NSMutableArray *classes = [NSMutableArray array];
    for (TalkGridModel *model in self.goods) {
        if ([model.department isEqualToString:@"dept3"]) {
            [classes addObject:model];
        }
    }
    return classes;
}

- (NSArray<TalkGridModel *> *)getTrainGoods {
    NSMutableArray *trains = [NSMutableArray array];
    for (TalkGridModel *model in self.goods) {
        if ([model.department isEqualToString:@"dept4"]) {
            [trains addObject:model];
        }
    }
    return trains;
}

@end
