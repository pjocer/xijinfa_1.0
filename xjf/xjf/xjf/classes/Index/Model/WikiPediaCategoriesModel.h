//
//  WikiPediaCategoriesModel.h
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol WikiPediaCategoriesDataModel

@end

@interface WikiPediaCategoriesDataModel : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@end


@interface WikiPediaCategoriesResultModel : JSONModel
@property (nonatomic, strong) NSArray <WikiPediaCategoriesDataModel, ConvertOnDemand> *data;
@end


@interface WikiPediaCategoriesModel : JSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) WikiPediaCategoriesResultModel *result;
@end


