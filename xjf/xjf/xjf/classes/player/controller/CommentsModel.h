//
//  CommentsModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CommentsModel
@end

@interface CommentsModel : JSONModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *reply_to;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_nickname;
@end

@interface CommentsResultModel : JSONModel
@property (nonatomic, strong) NSString *current_page;
@property (nonatomic, strong) NSArray <CommentsModel> *data;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *last_page;
@property (nonatomic, strong) NSString *next_page_url;
@property (nonatomic, strong) NSString *per_page;
@property (nonatomic, strong) NSString *prev_page_url;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *total;
@end

@interface CommentsAllDataList : JSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) CommentsResultModel *result;
@end


