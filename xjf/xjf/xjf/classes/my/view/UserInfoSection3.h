//
//  UserInfoSection3.h
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"

@interface UserInfoSection3 : UITableViewCell
@property (nonatomic, strong) UserProfileModel *model;
@property (nonatomic, strong) void (^InterestedBlock) (NSString *interested);
@property (nonatomic, strong) void (^ExperienceBlock) (NSString *experience);
@property (nonatomic, strong) void (^PreferenceBlock) (NSString *preference);
@end
