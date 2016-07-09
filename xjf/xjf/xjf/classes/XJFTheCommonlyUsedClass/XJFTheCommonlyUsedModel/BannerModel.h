//
//  BannerModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@protocol BannerResultModel

@end

@protocol BannerCover

@end

@interface BannerCover : JSONModel
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *url;
@end

@interface BannerResultModel : JSONModel
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *sorting;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *thumbnail NS_UNAVAILABLE;
@property (nonatomic, strong) NSArray <BannerCover> *cover;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *view;
@end


@interface BannerResultListModel : JSONModel
@property (nonatomic, strong) NSMutableArray <BannerResultModel> *data;
@end

@interface BannerModel : JSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) BannerResultListModel *result;
@end
