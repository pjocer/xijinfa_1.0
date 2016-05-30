//
//  OrderModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TalkGridModel.h"
@protocol OrderDataModel
@end


@interface OrderMembershipModel : JSONModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *period;
@end

@interface OrderDataModel : JSONModel
///订单号
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *user_id;
///订单状态
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *amount;
@property(nonatomic, assign) int status;
@property(nonatomic, strong) NSString *channel;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *updated_at;
@property(nonatomic, strong) NSArray <TalkGridModel, ConvertOnDemand> *items;
@property (nonatomic, strong) OrderMembershipModel *membership;
@property (nonatomic, strong) NSString *amount_display;
@property (nonatomic, strong) NSString *billing_channel;
@property (nonatomic, strong) NSString *billing_reference_id;
@end


@interface OrderResultModel : JSONModel
@property(nonatomic, strong) NSString *total;
@property(nonatomic, strong) NSString *per_page;
@property(nonatomic, strong) NSString *current_page;
@property(nonatomic, strong) NSString *last_page;
@property(nonatomic, strong) NSString *next_page_url;
@property(nonatomic, strong) NSString *prev_page_url;
@property(nonatomic, strong) NSString *from;
@property(nonatomic, strong) NSString *to;
@property(nonatomic, strong) NSArray <OrderDataModel, ConvertOnDemand> *data;
@end


@interface OrderModel : JSONModel
@property(nonatomic, assign) int errCode;
@property(nonatomic, strong) NSString *errMsg;
@property(nonatomic, strong) OrderResultModel *result;
@end
