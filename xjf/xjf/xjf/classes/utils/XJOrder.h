//
//  XJOrder.h
//  xjf
//
//  Created by PerryJ on 16/5/26.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkGridModel.h"
@interface XJOrder : NSObject

@property (nonatomic, strong) NSMutableArray <TalkGridModel *>*goods;

- (instancetype)initWith:(NSArray <TalkGridModel *> *)goods;

- (NSArray <TalkGridModel *>*)getClassGoods;

- (NSArray <TalkGridModel *>*)getTrainGoods;

- (void)orderCancel;

@end
