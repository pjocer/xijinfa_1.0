//
//  RechargeStream.h
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol RechargeStreamResultData <NSObject>

@end

@interface RechargeStreamResultData : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger account_id;
@property (assign, nonatomic) NSInteger amount;
@property (assign, nonatomic) NSInteger balance;
@property (assign, nonatomic) NSInteger _operator;
@property (copy, nonatomic) NSString *_description;
@property (copy, nonatomic) NSString *reference;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *updated_at;
@end

@interface RechargeStreamResult : JSONModel
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger per_page;
@property (assign, nonatomic) NSInteger current_page;
@property (assign, nonatomic) NSInteger last_page;
@property (assign, nonatomic) NSInteger from;
@property (assign, nonatomic) NSInteger to;
@property (copy, nonatomic) NSString *next_page_url;
@property (copy, nonatomic) NSString *prev_page_url;
@property (strong, nonatomic) NSMutableArray <RechargeStreamResultData>*data;
@end

@interface RechargeStreamModel : JSONModel
@property (assign, nonatomic) NSInteger errCode;
@property (copy, nonatomic) NSString *errMsg;
@property (strong, nonatomic) RechargeStreamResult *result;
@end
