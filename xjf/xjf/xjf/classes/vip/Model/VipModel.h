//
//  VipModel.h
//  xjf
//
//  Created by Hunter_wang on 16/6/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@protocol VipModel
@end

@protocol VipResultModel
@end


@interface VipModel : OptionalJSONModel
@property (nonatomic, strong) NSString *period;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@end


@interface VipResultModel : OptionalJSONModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray <VipModel> *deal;
@end


@interface VipListModel : OptionalJSONModel
@property (nonatomic, strong) NSString *errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSArray <VipResultModel> *result;
@end
