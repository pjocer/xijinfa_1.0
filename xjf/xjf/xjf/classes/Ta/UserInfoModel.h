//
//  UserInfoModel.h
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol UserMembership

@end

@interface UserMembership : JSONModel
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@end

@interface UserInfoModel : JSONModel
@property (nonatomic, copy) NSString *account_balance;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *coin_balance;
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
@property (nonatomic, strong) NSMutableArray <UserMembership> *membership;
@end
