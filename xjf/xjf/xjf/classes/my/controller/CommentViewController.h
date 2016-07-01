//
//  MyCommentViewController.h
//  xjf
//
//  Created by PerryJ on 16/6/3.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyBaseViewController.h"
#import "TopicModel.h"
#import "UserInfoModel.h"

/**
 Comment VC
    Include my comment & Others
 - returns: instance
 */
@interface CommentViewController : MyBaseViewController
- (instancetype)initWith:(UserInfoModel *)user;
@end
