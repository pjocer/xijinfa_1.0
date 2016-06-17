//
//  UserInfoCell.h
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"

@interface UserInfoCell : UITableViewCell
@property (nonatomic, strong) UserProfileModel *model;
@property (nonatomic, copy) void (^NicknameBlock)(NSString *nickname);
@property (nonatomic, copy) void (^SummaryBlock)(NSString *summary);
@end
