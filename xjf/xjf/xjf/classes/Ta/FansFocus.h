//
//  FansFocus.h
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"
#import "UserInfoModel.h"

@protocol UserInfoModel

@end

@interface FansFocusResult : JSONModel
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray <UserInfoModel> *data;
@end

@interface FansFocus : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) FansFocusResult *result;
@end
