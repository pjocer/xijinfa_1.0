//
//  RechargeList.h
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@protocol RechargeDeal <NSObject>

@end
@interface RechargeDeal : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger bonus;
@end

@interface RechargeResult : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray <RechargeDeal>*deal;
@end

@interface RechargeList : JSONModel
@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) RechargeResult *result;
@end
