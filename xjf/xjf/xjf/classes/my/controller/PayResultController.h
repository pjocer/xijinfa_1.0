//
//  RechargeResultController.h
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    RechargeType = 0,
    PurchaseType,
} PayResultType;

@interface PayResultController : BaseViewController
- (instancetype)initWithSuccess:(BOOL)isSuccess type:(PayResultType)type;
@end
