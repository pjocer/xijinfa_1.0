//
//  LessonDetailListModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol LessonDetailVideo
@end

@protocol LessonDetailListLessonsModel
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


@interface LessonDetailListLessonsModel : JSONModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *original_price;
//@property (nonatomic, strong) NSArray <LessonDetailPackage, ConvertOnDemand> *package;
@property (nonatomic, strong) LessonDetailPivot *pivot;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSArray <LessonDetailVideo, ConvertOnDemand>*video;
@property (nonatomic, strong) NSString *view;
@end


@interface LessonDetailListResultModel : JSONModel
@property (nonatomic, strong) NSString *api_href;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_album;
@property (nonatomic, strong) NSString *is_favorite;
@property (nonatomic, strong) NSString *is_learn;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSArray <LessonDetailListLessonsModel, ConvertOnDemand> *lessons;
@property (nonatomic, strong) NSString *original_price;
//package 数组这里没写
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *purchased;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *updated_at;
//vide数组没写
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *view;

@end


@interface LessonDetailListModel : JSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) LessonDetailListResultModel *result;
@end
