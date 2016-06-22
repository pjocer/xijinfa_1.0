//
//  XJAccountManager.h
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserProfileModel.h"

#define TOKEN_INVALID_STATUS 206
#define TOKEN_INVALID @"token_invalid"

#define KEY_USER_PROFILE @"user_profile"
#define KEY_ACCOUNT_TYPE @"account_type"
#define KEY_CURRENT_USER_NAME @"current_user_name"

FOUNDATION_EXTERN UIViewController *getCurrentDisplayController(void);

typedef enum : NSUInteger {
    NormalAccount,
    VIPAccount,
} AcccountType;

@interface XJAccountManager : NSObject
@property (nonatomic, strong) UserProfileModel *user_model;
@property (nonatomic, assign) AcccountType account_type;

+ (instancetype)defaultManager;

- (BOOL)verifyValid;

- (NSString *)accessToken;

- (NSString *)user_id;

- (void)setAccuontInfo:(NSDictionary *)info;

- (void)updateUserInfo;

- (instancetype)init NS_UNAVAILABLE;

- (void)logout;
@end
