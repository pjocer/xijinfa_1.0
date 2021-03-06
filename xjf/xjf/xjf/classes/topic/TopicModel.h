//
//  TopicModel.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"
#import "UserInfoModel.h"

@protocol CategoryLabel

@end

@protocol TopicDataModel

@end

@interface CategoryLabel : OptionalJSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *thumbnail;
@end

@interface TopicDataModel : OptionalJSONModel
@property (nonatomic, copy) NSMutableArray <CategoryLabel> *taxonomy_tags;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL user_favored;
@property (nonatomic, assign) BOOL user_liked;
@property (nonatomic, copy) NSString *reply_count;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *dislike_count;
@property (nonatomic, copy) NSString *transfer_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *topic_content;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, strong) UserInfoModel *user;
@end

@interface TopicResultModel : OptionalJSONModel
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray <TopicDataModel> *data;
@end

@interface TopicModel : OptionalJSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) TopicResultModel *result;
@end
