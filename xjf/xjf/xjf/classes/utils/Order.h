//
//  Order.h
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol OrderItem

@end

@protocol Payment

@end

@interface OrderItemVideo : JSONModel
@property (nonatomic, copy) NSString *video_auto;
@property (nonatomic, copy) NSString *view;
@end

@interface OrderItem : JSONModel
@property (nonatomic, copy) NSString *api_href;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *icon_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *is_album;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *lessons_duration;
@property (nonatomic, copy) NSString *organization;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *purchased;
@property (nonatomic, copy) NSString *sorting;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subscribed;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, strong) NSMutableArray *package;
@property (nonatomic, strong) OrderItemVideo *vedio;
@end

@interface Membership : JSONModel
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *type;
@end

@interface Payment : JSONModel
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *data;
@end

@interface OrderResult : JSONModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *billing_channel;
@property (nonatomic, copy) NSString *billing_reference_id;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSMutableArray <OrderItem>*items;
@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) NSMutableArray <Payment>*payment;
@end

@interface Order : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) OrderResult *result;
@end
