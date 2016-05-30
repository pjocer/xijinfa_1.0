//
//  XJOrder.m
//  xjf
//
//  Created by PerryJ on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJOrder.h"

@implementation XJOrder

-(instancetype)initWith:(NSArray<TalkGridModel *> *)goods {
    self = [super init];
    if (self) {
        _goods = [NSMutableArray array];
        for (TalkGridModel *model in goods) {
            [_goods addObject:model];
        }
    }
    return self;
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
