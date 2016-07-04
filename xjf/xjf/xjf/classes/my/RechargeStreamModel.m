//
//  RechargeStream.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RechargeStreamModel.h"

@implementation RechargeStreamModel
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation RechargeStreamResult
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation RechargeStreamResultData
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"operator":@"_operator",@"description":@"_description"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end