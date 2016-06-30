//
//  UserInfoController.h
//  xjf
//
//  Created by PerryJ on 16/6/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyBaseViewController.h"

typedef enum : NSUInteger {
    Myself,
    Ta,
} UserType;
@class UserInfoModel;
@interface UserInfoController : MyBaseViewController
@property (nonatomic, assign) UserType userType;
-(instancetype)initWithUserType:(UserType)type userInfo:(UserInfoModel *)model;
@end
