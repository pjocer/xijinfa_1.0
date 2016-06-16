//
//  OrderModel.m
//  xjf
//
//  Created by Hunter_wang on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end


@implementation OrderResultModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end


@implementation OrderDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation OrderMembershipModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end