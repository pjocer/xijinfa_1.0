//
//  CommentsViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentsModel.h"
@interface CommentsViewController : BaseViewController
///评论数据
@property (nonatomic, strong) CommentsAllDataList *commentsModel;
@end
