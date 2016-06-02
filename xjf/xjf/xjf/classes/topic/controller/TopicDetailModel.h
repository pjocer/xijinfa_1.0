//
//  TopicDetailModel.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TopicCategoryLabel

@end

@interface DetailPivot : JSONModel
@property (nonatomic, copy) NSString *classification_id;
@property (nonatomic, copy) NSString *category_id;
@end

@interface TopicCategoryLabel : JSONModel
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
@property (nonatomic, strong) DetailPivot *pivot;
@end

@interface TopiceMembership : JSONModel
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@end


@interface TopicDetailUser : JSONModel
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
@property (nonatomic, strong) TopiceMembership *membership;
@end

@interface TopicDetailResult : JSONModel
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL user_favorite;
@property (nonatomic, assign) BOOL user_liked;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *reply_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, strong) TopicDetailUser *user;
@property (nonatomic, strong) NSMutableArray <TopicCategoryLabel>*categories;
@end

@interface TopicDetailModel : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) TopicDetailResult *result;
@end
