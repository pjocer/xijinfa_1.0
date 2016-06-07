//
//  CommentDetailHeader.h
//  xjf
//
//  Created by PerryJ on 16/5/31.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"
@interface CommentDetailHeader : UITableViewCell
@property (nonatomic, strong) TopicDataModel *model;
@property (nonatomic, assign) CGFloat cellHeight;
@end
