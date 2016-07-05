//
//  TeacherListHostModel.h
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol TeacherListData
@end

@protocol TeacherListVideo
@end


@interface TeacherListVideo : JSONModel
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *url;
@end


@interface TeacherListData : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int view;
@property (nonatomic, assign) int sorting;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *api_href;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSArray <TeacherListVideo, ConvertOnDemand> *video_player;
///(已登录用户)是否已点赞
@property (nonatomic, assign) BOOL user_liked;
///(已登录用户)是否已收藏
@property (nonatomic, assign) BOOL user_favored;
///(已登录用户)播放历史, 秒
@property (nonatomic, strong) NSString *user_played;
///视频时长
@property (nonatomic, strong) NSString *video_duration;
///视频播放次数
@property (nonatomic, strong) NSString *video_view;
@property (nonatomic, strong) NSString *guru_avatar;
@end


@interface TeacherListResult : JSONModel
@property (nonatomic, assign) int current_page;
@property (nonatomic, strong) NSArray <TeacherListData, ConvertOnDemand> *data;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) int last_page;
@property (nonatomic, strong) NSString *next_page_url;
@property (nonatomic, strong) NSString *per_page;
@property (nonatomic, strong) NSString *prev_page_url;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *total;
@end


@interface TeacherListHostModel : JSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) TeacherListResult *result;
@end
