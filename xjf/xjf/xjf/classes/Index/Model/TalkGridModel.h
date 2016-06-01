//
//  TalkGridModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TalkGridModel
@end

@protocol TalkGridVideo
@end

@interface TalkGridVideo : JSONModel
@property(nonatomic, strong) NSString *resolution;
@property(nonatomic, strong) NSString *url;
@end


@interface TalkGridModel : JSONModel

@property(nonatomic, strong) NSString *api_href;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *department;
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *id_;
@property(nonatomic, strong) NSString *is_album;
///关键字
@property(nonatomic, strong) NSString *keywords;
///原价
@property(nonatomic, strong) NSString *original_price;
@property(nonatomic, strong) NSString *lessons_count;
@property(nonatomic, strong) NSString *lessons_duration;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *purchased;
@property(nonatomic, strong) NSString *sorting;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *subscribed;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *summary;
@property(nonatomic, strong) NSString *thumbnail;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *updated_at;
///(已登录用户)是否已收藏
@property(nonatomic, assign) BOOL user_favored;
@property(nonatomic, strong) NSString *user_id;
///(已登录用户)是否已点赞
@property(nonatomic, assign) BOOL user_liked;
///(已登录用户)是否已付费(含购买订阅但不含免费)
@property(nonatomic, assign) BOOL user_paid;
///(已登录用户)是否已购买
@property(nonatomic, assign) BOOL user_purchased;
///(已登录用户)是否已订阅
@property(nonatomic, assign) BOOL user_subscribed;
///(已登录用户)播放历史, 秒
@property(nonatomic, strong) NSString *user_played;
///视频时长
@property(nonatomic, strong) NSString *video_duration;
///视频播放次数
@property(nonatomic, strong) NSString *video_view;
@property(nonatomic, strong) NSString *view;
@property(nonatomic, strong) NSArray <TalkGridVideo, ConvertOnDemand> *video_player;
@property(nonatomic, assign) BOOL isSelected;
@end


@interface TablkResultModel : JSONModel
@property(nonatomic, assign) int current_page;
@property(nonatomic, strong) NSArray <TalkGridModel, ConvertOnDemand> *data;
@property(nonatomic, strong) NSString *from;
@property(nonatomic, assign) int last_page;
@property(nonatomic, strong) NSString *next_page_url;
@property(nonatomic, strong) NSString *per_page;
@property(nonatomic, strong) NSString *prev_page_url;
@property(nonatomic, strong) NSString *to;
@property(nonatomic, strong) NSString *total;

@end

@interface TablkListModel : JSONModel

@property(nonatomic, assign) int errCode;
@property(nonatomic, strong) NSString *errMsg;
@property(nonatomic, strong) TablkResultModel *result;

@end



