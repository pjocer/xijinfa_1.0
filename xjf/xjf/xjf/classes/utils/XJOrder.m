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
@implementation XJOrder

-(instancetype)initWith:(NSArray<TalkGridModel *> *)goods {
    self = [super init];
    if (self) {
        _goods = [NSMutableArray array];
        for (TalkGridModel *model in goods) {
            [_goods addObject:model];
        }
        [self initOrder];
    }
    return self;
}

- (void)initOrder {
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:buy_trade RequestMethod:POST];
    NSString *access_token = [[XJAccountManager defaultManager] accessToken];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",access_token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"items":_goods}];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        @strongify(self)
        self.order = [[Order alloc] initWithData:responseData error:nil];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"生成订单失败"];
    }];
}

-(void)orderCancel {
    
    self.goods = nil;
}

-(NSArray<TalkGridModel *> *)getClassGoods {
    NSMutableArray *classes = [NSMutableArray array];
    for (TalkGridModel *model in self.goods) {
        if ([model.department isEqualToString:@"dept3"]) {
            [classes addObject:model];
        }
    }
    return classes;
}

-(NSArray<TalkGridModel *> *)getTrainGoods {
    NSMutableArray *trains = [NSMutableArray array];
    for (TalkGridModel *model in self.goods) {
        if ([model.department isEqualToString:@"dept4"]) {
            [trains addObject:model];
        }
    }
    return trains;
}

@end
