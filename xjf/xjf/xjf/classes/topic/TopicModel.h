//
//  TopicModel.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"

@protocol CategoryLabel

@end

@protocol TopicDataModel

@end


@interface Pivot : JSONModel
@property (nonatomic, copy) NSString *classification_id;
@property (nonatomic, copy) NSString *category_id;
@end

@interface CategoryLabel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *taxonomy_tags;
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
@property (nonatomic, assign) BOOL user_favored;
@property (nonatomic, assign) BOOL user_liked;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *reply_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *topic_content;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, strong) UserInfoModel *user;
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
@property (nonatomic, assign) int errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) TopicResultModel *result;
@end
