//
//  LessonDetailListModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TalkGridModel.h"
#import "TeacherListHostModel.h"

@protocol LessonDetailVideo
@end

@protocol LessonDetailListLessonsModel
@end

@protocol Taxonomy_categories
@end

@protocol LessonDetailListCover
@end

@interface Taxonomy_categories : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *thumbnail;
@end

@interface LessonDetailVideo : JSONModel
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *url;
@end

@interface LessonDetailPivot : JSONModel
@property (nonatomic, strong) NSString *attached_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *main_id;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *updated_at;
@end

@interface LessonDetailListCover : JSONModel
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *url;
@end

@interface LessonDetailListResultModel : JSONModel

@property (nonatomic, strong) NSArray <TalkGridModel> *lessons_menu;
@property (nonatomic, strong) NSArray <TeacherListData> *taxonomy_gurus;
@property (nonatomic, strong) NSArray <Taxonomy_categories> *taxonomy_categories;
@property (nonatomic, strong) NSString *api_href;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *icon NS_UNAVAILABLE;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_album;
///关键字
@property (nonatomic, strong) NSString *keywords;
///原价
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *lessons_count;
@property (nonatomic, strong) NSString *lessons_duration;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *purchased;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *thumbnail NS_UNAVAILABLE;
@property (nonatomic, strong) NSArray <LessonDetailListCover> *cover;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *package;
@property (nonatomic, strong) NSString *updated_at;
///(已登录用户)是否已收藏
@property (nonatomic, assign) BOOL user_favored;
@property (nonatomic, strong) NSString *user_id;
///点赞次数
@property (nonatomic, strong) NSString *likes_count;
///(已登录用户)是否已点赞
@property (nonatomic, assign) BOOL user_liked;
///(已登录用户)是否已付费(含购买订阅但不含免费)
@property (nonatomic, assign) BOOL user_paid;
///(已登录用户)是否已购买
@property (nonatomic, assign) BOOL user_purchased;
///(已登录用户)是否已订阅
@property (nonatomic, assign) BOOL user_subscribed;
///(已登录用户)播放历史, 秒
@property (nonatomic, strong) NSString *user_played;
///视频时长
@property (nonatomic, strong) NSString *video_duration;
///视频播放次数
@property (nonatomic, strong) NSString *video_view;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSArray <TalkGridVideo, ConvertOnDemand> *video_player;

@end

@interface LessonDetailListModel : JSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) LessonDetailListResultModel *result;
@end
