//
//  TopicCommentList.h
//  xjf
//
//  Created by PerryJ on 16/5/31.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"
#import "TopicModel.h"

@interface CommentListResult : JSONModel
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, strong) NSMutableArray <TopicDataModel> *data;
@end

@interface TopicCommentList : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) CommentListResult *result;
@end
