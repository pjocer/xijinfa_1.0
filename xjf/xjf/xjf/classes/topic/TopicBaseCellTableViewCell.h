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

@interface TopicBaseCellTableViewCell : UITableViewCell
@property (nonatomic, strong) TopicDataModel *model;
@property (nonatomic, assign) CGFloat cellHeight;
@end
