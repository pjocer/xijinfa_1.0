//
//  TopicCommentList.h
//  xjf
//
//  Created by PerryJ on 16/5/31.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CommentData

@end

@protocol CommentMembership

@end

@interface CommentMembership : JSONModel
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@end

@interface CommentUserData : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *invest_category;
@property (nonatomic, copy) NSString *invest_age;
@property (nonatomic, copy) NSString *invest_type;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *following;
@property (nonatomic, copy) NSString *follower;
@property (nonatomic, copy) NSString *account_balance;
@property (nonatomic, copy) NSString *coin_balance;
@property (nonatomic, copy) NSString *credit_balance;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, strong) NSMutableArray <CommentMembership>*membership;

@end

@interface CommentData : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *reply_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *to_user_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *reply_count;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, assign) BOOL user_favorite;
@property (nonatomic, assign) BOOL user_liked;
@property (nonatomic, strong) CommentUserData *user;
@end

@interface CommentListResult : JSONModel
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, strong) NSMutableArray <CommentData>*data;
@end

@interface TopicCommentList : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) CommentListResult *result;
@end
