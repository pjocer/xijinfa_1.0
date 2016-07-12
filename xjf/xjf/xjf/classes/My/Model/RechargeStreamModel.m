//
//  RechargeStream.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RechargeStreamModel.h"

@implementation RechargeStreamModel
@end

@implementation RechargeStreamResult
@end

@implementation RechargeStreamResultData
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
            @"operator" : @"_operator",
            @"description" : @"_description"}];
}
@end