//
//  TeacherDetailModel.h
//  xjf
//
//  Created by Hunter_wang on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"
#import "TalkGridModel.h"


@protocol TeacherDetailCover

@end

@interface TeacherDetailCover : JSONModel
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *url;
@end

@interface TeacherDetailResult : JSONModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int user_id;
///(已登录用户)是否已收藏
@property (nonatomic, assign) BOOL user_favored;
///(已登录用户)是否已点赞
@property (nonatomic, assign) BOOL user_liked;
@property (nonatomic, strong) NSArray <TalkGridModel, ConvertOnDemand> *guru_courses;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *guru_avatar;
@property (nonatomic, strong) NSString *comments_count;
@property (nonatomic, strong) NSArray <TeacherDetailCover> *cover;
@end


@interface TeacherDetailModel : JSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) TeacherDetailResult *result;
@end
