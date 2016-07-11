//
//  EmployedbundleModel.h
//  xjf
//
//  Created by Hunter_wang on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TalkGridModel.h"

@interface EmployedbundleModel : JSONModel
@property (nonatomic, assign) int errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) TalkGridModel *result;
@end
