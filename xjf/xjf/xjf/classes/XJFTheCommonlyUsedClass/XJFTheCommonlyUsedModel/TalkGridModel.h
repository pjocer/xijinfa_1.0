//
//  TalkGridModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@protocol TalkGridModel
@end

@protocol TalkGridVideo
@end

@protocol taxonomy_gurus
@end

@protocol TalkGridCover
@end

@interface taxonomy_gurus : OptionalJSONModel
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSArray <TalkGridCover> *cover;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *guru_avatar;
@property (nonatomic, strong) NSString *comments_count;
@property (nonatomic, strong) NSString *user_played;
@property (nonatomic, strong) NSString *user_played_at;
@property (nonatomic, strong) NSString *user_favored;
@property (nonatomic, strong) NSString *user_liked;
@end

@interface TalkGridVideo : OptionalJSONModel
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *url;
@end


@interface TalkGridCover : OptionalJSONModel
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *url;
@end

@interface TalkGridModel : OptionalJSONModel
@property (nonatomic, strong) NSArray <TalkGridModel, ConvertOnDemand> *children;
@property (nonatomic, strong) NSString *api_href;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *icon NS_UNAVAILABLE;
@property (nonatomic, strong) NSArray <TalkGridCover> *cover;
@property (nonatomic, strong) NSString *id_;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *is_album;
///关键字
@property (nonatomic, strong) NSString *keywords;
///原价
@property (nonatomic, strong) NSString *original_price;
@property (nonatomic, strong) NSString *lessons_count;
@property (nonatomic, assign) float lessons_duration;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *purchased;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *thumbnail NS_UNAVAILABLE;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSArray *package;
///用户在什么时候播放的视频
@property (nonatomic, strong) NSString *user_played_at;
///(已登录用户)是否已收藏
@property (nonatomic, assign) BOOL user_favored;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *like_count;
///(已登录用户)是否已点赞
@property (nonatomic, assign) BOOL user_liked;
///(已登录用户)是否已付费(含购买订阅但不含免费)
@property (nonatomic, assign) BOOL user_paid;
///(已登录用户)是否已购买
@property (nonatomic, assign) BOOL user_purchased;
///(已登录用户)是否已订阅
@property (nonatomic, assign) BOOL user_subscribed;
///(已登录用户)播放记录, 秒
@property (nonatomic, strong) NSString *user_played;
///是否已经学习
@property (nonatomic, assign) int user_learned;
///视频时长
@property (nonatomic, assign) NSInteger video_duration;
///视频播放次数
@property (nonatomic, strong) NSString *video_view;
@property (nonatomic, strong) NSString *view_count;
@property (nonatomic, strong) NSArray <TalkGridVideo, ConvertOnDemand> *video_player;
@property (nonatomic, strong) NSArray <taxonomy_gurus> *taxonomy_gurus;
@property (nonatomic, strong) NSArray <TalkGridModel> *courses_menu;
@property (nonatomic, strong) NSString *api_uri;
@property (nonatomic, assign) BOOL isSelected;
@end


@interface TablkResultModel : OptionalJSONModel
@property (nonatomic, assign) int current_page;
@property (nonatomic, strong) NSArray <TalkGridModel> *data;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) int last_page;
@property (nonatomic, strong) NSString *next_page_url;
@property (nonatomic, strong) NSString *per_page;
@property (nonatomic, strong) NSString *prev_page_url;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *total;

@end

@interface TablkListModel : OptionalJSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) TablkResultModel *result;
@end
