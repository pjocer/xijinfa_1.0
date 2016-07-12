//
//  WikiPediaCategoriesModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"
#import "TalkGridModel.h"

@protocol WikiPediaCategoriesDataModel

@end

@interface WikiPediaCategoriesDataModel : OptionalJSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <TalkGridCover> *cover;
@end


@interface WikiPediaCategoriesResultModel : OptionalJSONModel
@property (nonatomic, strong) NSArray <WikiPediaCategoriesDataModel, ConvertOnDemand> *data;
@end


@interface WikiPediaCategoriesModel : OptionalJSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) WikiPediaCategoriesResultModel *result;
@end
