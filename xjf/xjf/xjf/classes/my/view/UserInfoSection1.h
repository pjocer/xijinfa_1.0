//
//  UserInfoSection1.h
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"

@interface UserInfoSection1 : UITableViewCell
@property (nonatomic, strong) UserProfileModel *model;
@property (nonatomic, strong) void (^SexBlock) (NSString *sex);
@property (nonatomic, strong) void (^CityBlock) (NSString *city);
@property (nonatomic, strong) void (^AgeBlock) (NSString *age);
@end
