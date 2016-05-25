//
//  Order.m
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "Order.h"

@implementation PaymentData
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Payment
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Membership
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation OrderItemVideo

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"auto":@"video_auto"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation OrderItem
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation OrderResult
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Order
+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
