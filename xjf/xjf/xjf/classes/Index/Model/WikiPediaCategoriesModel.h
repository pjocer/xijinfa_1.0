//
//  WikiPediaCategoriesModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  WikiPediaCategoriesDataModel

@end

@interface WikiPediaCategoriesDataModel : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *image_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *object_count;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *taxonomy;
@property (nonatomic, strong) NSString *updated_at;
@end


@interface WikiPediaCategoriesResultModel : NSObject
@property (nonatomic, strong) NSString *current_page;
@property (nonatomic, strong) NSMutableArray *dataModelArray;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *last_page;
@property (nonatomic, strong) NSString *next_page_url;
@property (nonatomic, strong) NSString *per_page;
@property (nonatomic, strong) NSString *prev_page_url;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *total;
@end


@interface WikiPediaCategoriesModel : NSObject
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) WikiPediaCategoriesResultModel *resultModel;
@end


