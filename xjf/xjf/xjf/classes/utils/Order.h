//
//  Order.h
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PaymentData : JSONModel
/** 商家向财付通申请的商家id */
@property (nonatomic, copy) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, copy) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, copy) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, copy) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy) NSString *sign;
/** appid */
@property (nonatomic, copy) NSString *appid;

@end

@protocol OrderItem

@end

@protocol Payment

@end

@protocol TaxonomyCategories

@end

@protocol TaxonomyGurus

@end

@protocol TaxonomyTags

@end

@interface OrderItemVideo : JSONModel
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, copy) NSString *url;
@end

@interface TaxonomyCategories : JSONModel
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@end

@interface TaxonomyGurus : JSONModel
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger user_favored;
@property (nonatomic, assign) NSInteger user_liked;
@property (nonatomic, assign) NSInteger user_played;
@property (nonatomic, copy) NSString *guru_avatar;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *user_played_at;
@end

@interface TaxonomyTags : JSONModel

@end

@interface OrderItem : JSONModel
@property (nonatomic, copy) NSString *api_uri;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger favorites_count;
@property (nonatomic, assign) NSInteger finish;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger origin;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_album;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *lessons_duration;
@property (nonatomic, copy) NSString *lessons_count;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *sorting;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *web_uri;
@property (nonatomic, copy) NSString *video_view;
@property (nonatomic, assign) float video_duration;
@property (nonatomic, copy) NSString *user_played;
@property (nonatomic, copy) NSString *user_played_at;
@property (nonatomic, copy) NSString *user_favored;
@property (nonatomic, copy) NSString *user_learned;
@property (nonatomic, copy) NSString *user_lessons_learned;
@property (nonatomic, copy) NSString *user_liked;
@property (nonatomic, copy) NSString *user_purchased;
@property (nonatomic, copy) NSString *user_subscribed;
@property (nonatomic, copy) NSString *user_paid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, strong) NSMutableArray *package;
@property (nonatomic, strong) OrderItemVideo *video_player;
@property (nonatomic, strong) NSMutableArray <TaxonomyCategories> *taxonomy_categories;
@property (nonatomic, strong) NSMutableArray <TaxonomyGurus> *taxonomy_gurus;
@property (nonatomic, strong) NSMutableArray <TaxonomyTags> *taxonomy_tags;
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
@property (nonatomic, copy) NSString *amount_display;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *billing_channel;
@property (nonatomic, copy) NSString *billing_reference_id;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSMutableArray <OrderItem> *items;
@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) NSMutableArray <Payment> *payment;
@end

@interface Order : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) OrderResult *result;
@end
