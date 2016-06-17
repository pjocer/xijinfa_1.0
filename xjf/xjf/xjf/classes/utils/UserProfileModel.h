//
//  UserProfileModel.h
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserProfileModel.h"
#import "UserInfoModel.h"

@interface UserProfileModel : JSONModel
@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) UserInfoModel *result;
@end
