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
/**
 *  User Info Model
 */
@property (nonatomic, strong) UserProfileModel *user_model;
/**
 *  Vip Or Normal Account Type
 */
@property (nonatomic, assign) AcccountType account_type;

+ (instancetype)defaultManager;
/**
 *  Verify The Validty Of Account Info
 *
 *  @return Valid Or Not
 */
- (BOOL)verifyValid;
/**
 *  Get Account Access Token
 *
 *  @return Access Token
 */
- (NSString *)accessToken;
/**
 *  Get Account User ID
 *
 *  @return User ID
 */
- (NSString *)user_id;
/**
 *  Set User Info By Model Which Request From Server
 *
 *  @param info AccountFinalModel To Dictionary
 */
- (void)setAccuontInfo:(NSDictionary *)info;
/**
 *  Update User Info
 */
- (void)updateUserInfoCompeletionBlock:(void (^) (UserProfileModel *model))compeletionBlock;
/**
 *  Logout
 */
- (void)logout;
- (instancetype)init NS_UNAVAILABLE;
@end
