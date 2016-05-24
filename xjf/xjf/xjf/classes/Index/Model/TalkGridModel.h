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
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *url;
@end


@interface TalkGridModel : JSONModel

@property (nonatomic, strong) NSString *api_href;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *id_;
@property (nonatomic, strong) NSString *is_album;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *lessons_count;
@property (nonatomic, strong) NSString *lessons_duration;
@property (nonatomic, strong) NSString *original_price;
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
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *view_;
@property (nonatomic, strong) NSArray<TalkGridVideo, ConvertOnDemand>*video;
@end


@interface TablkResultModel : JSONModel
@property (nonatomic, strong) NSString *current_page;
@property (nonatomic, strong)  NSArray<TalkGridModel, ConvertOnDemand>* data;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *last_page;
@property (nonatomic, strong) NSString *next_page_url;
@property (nonatomic, strong) NSString *per_page;
@property (nonatomic, strong) NSString *prev_page_url;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *total;

@end

@interface TablkListModel : JSONModel

@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) TablkResultModel *result;

@end



