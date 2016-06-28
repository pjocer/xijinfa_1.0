//
//  TopicBaseCellTableViewCell.h
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"
#import "TopicDetailModel.h"
#import "XJFBaseTableViewCell.h"

@interface TopicBaseCellTableViewCell : XJFBaseTableViewCell
@property (nonatomic, strong) TopicDataModel *model;
@property (nonatomic, assign) CGFloat cellHeight __deprecated_msg("user xib instead");
@end
