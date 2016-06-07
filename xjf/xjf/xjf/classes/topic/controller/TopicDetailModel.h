//
//  TopicDetailModel.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TopicModel.h"

@interface TopicDetailModel : JSONModel
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) TopicDataModel *result;
@end
