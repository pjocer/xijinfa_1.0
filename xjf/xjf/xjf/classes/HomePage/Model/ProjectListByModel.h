//
//  ProjectListByModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@protocol ProjectList

@end

@protocol ProjectListCover

@end

@interface ProjectListCover : OptionalJSONModel
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *url;
@end

@interface ProjectList : OptionalJSONModel
@property (nonatomic, assign) NSInteger favorite_count;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger sale_count;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray <ProjectListCover> *cover;
@property (nonatomic, strong) NSMutableArray <ProjectList> *children;
@end

@interface ProjectListResult : OptionalJSONModel
@property (nonatomic, strong) NSMutableArray <ProjectList> *data;
@end

@interface ProjectListByModel : OptionalJSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) ProjectListResult *result;
@end
