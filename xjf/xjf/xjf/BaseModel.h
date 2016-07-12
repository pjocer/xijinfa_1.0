//
//  BaseModel.h
//  xjf
//
//  Created by PerryJ on 16/7/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ModelProtocols.h"
/**
 *  Base model properties is optional
 */
@interface BaseModel : JSONModel
@end
/**
 *  图片验证码
 */
@interface ImageCode : BaseModel
@property (nonatomic, copy) NSString *secure_code;
@property (nonatomic, copy) NSString *secure_image;
@property (nonatomic, copy) NSString *secure_key;
@end
/**
 *  会员
 */
@interface Membership : BaseModel
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *type;
@end
/**
 *  用户信息
 */
@interface UserInfo : BaseModel
@property (nonatomic, assign) NSInteger account_balance;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger coin_balance;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *credit_balance;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *follower;
@property (nonatomic, copy) NSString *following;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *invest_age;
@property (nonatomic, copy) NSString *invest_category;
@property (nonatomic, copy) NSString *invest_type;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, assign) NSInteger topic_count;
@property (nonatomic, assign) NSInteger reply_count;
@property (nonatomic, assign) NSInteger guru_count;
@property (nonatomic, assign) NSInteger course_count;
@property (nonatomic, strong) NSMutableArray <Membership> *membership;
@end
/**
 *  AccessToken
 */
@interface Credential : BaseModel
@property (nonatomic, copy) NSString *bearer;
@property (nonatomic, copy) NSString *expired_at;
@end
/**
 *  原始用户信息
 */
@interface OriginInfo : BaseModel
@property (nonatomic, strong) Credential *credential;
@property (nonatomic, strong) UserInfo *user;
@end