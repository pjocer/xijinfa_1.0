//
//  asdad.h
//  xjf
//
//  Created by PerryJ on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfoResultAccountModel : JSONModel
@property (nonatomic, copy) NSString *available;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *freeze;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@end

@interface AccountInfoResultModel : JSONModel
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *coin_balance;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *credit_balance;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *followers;
@property (nonatomic, copy) NSString *followings;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *invest_age;
@property (nonatomic, copy) NSString *invest_category;
@property (nonatomic, copy) NSString *invest_type;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *remember_token;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) AccountInfoResultAccountModel *account;
@end

@interface AccountInfoModel : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) AccountInfoResultModel *result;
@end
/**
 Init User Info
 
 - returns: Null
 */
//FOUNDATION_EXTERN void initAccountInfo (void) NS_UNAVAILABLE;
/**
 Update User Info
 
 - returns: Null
 */
//FOUNDATION_EXTERN void updateAccountInfo(void) NS_UNAVAILABLE;
/**
 Get Current Display Controller
 
 - returns: Current Display Controller
 */
FOUNDATION_EXTERN UIViewController *_Nullable getCurrentDisplayController(void);
/**
 Get Current User Info
 
 - returns: Current User Info
 */
FOUNDATION_EXTERN AccountInfoModel *_Nullable getCurrentUserInfo(void);
/**
 *  Get User Access Token
 */
FOUNDATION_EXTERN NSString *_Nullable getUserAccessToken(void);


