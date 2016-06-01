//
//  TopicModel.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TopictMembershipModel

@end

@protocol CategoryLabel

@end

@protocol TopicDataModel

@end

@interface TopictMembershipModel : JSONModel
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@end

@interface TopicUserModel : JSONModel 
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
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) NSMutableArray <TopictMembershipModel>*membership;
@end

@interface Pivot : JSONModel
@property (nonatomic, copy) NSString *classification_id;
@property (nonatomic, copy) NSString *category_id;
@end

@interface CategoryLabel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *taxonomy;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *object_count;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) Pivot *pivot;
@end

@interface TopicDataModel : JSONModel
@property (nonatomic, copy) NSMutableArray <CategoryLabel>*categories;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *reply_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, strong) TopicUserModel *user;
@end

@interface TopicResultModel : JSONModel
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray <TopicDataModel>*data;
@end

@interface TopicModel : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) TopicResultModel *result;
@end
