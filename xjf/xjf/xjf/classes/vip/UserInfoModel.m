//
//  UserInfoModel.m
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserMembership
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation UserInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
