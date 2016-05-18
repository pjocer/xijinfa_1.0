//
//  UserProfileModel.h
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoResultAccountModel : JSONModel
@property(nonatomic, copy) NSString *available;
@property(nonatomic, copy) NSString *balance;
@property(nonatomic, copy) NSString *created_at;
@property(nonatomic, copy) NSString *freeze;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *updated_at;
@property(nonatomic, copy) NSString *user_id;
@end

@interface UserInfoResultModel : JSONModel
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *coin_balance;
@property(nonatomic, copy) NSString *created_at;
@property(nonatomic, copy) NSString *credit_balance;
@property(nonatomic, copy) NSString *deleted_at;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *followers;
@property(nonatomic, copy) NSString *followings;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *image_id;
@property(nonatomic, copy) NSString *invest_age;
@property(nonatomic, copy) NSString *invest_category;
@property(nonatomic, copy) NSString *invest_type;
@property(nonatomic, copy) NSString *level;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *quote;
@property(nonatomic, copy) NSString *remember_token;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *updated_at;
@property(nonatomic, strong) UserInfoResultAccountModel *account;
@end

@interface UserProfileModel : JSONModel
@property(nonatomic, copy) NSString *errCode;
@property(nonatomic, copy) NSString *errMsg;
@property(nonatomic, strong) UserInfoResultModel *result;
@end
