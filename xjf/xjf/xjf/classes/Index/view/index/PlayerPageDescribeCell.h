//
//  PlayerPageDescribeCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"

@interface PlayerPageDescribeCell : UICollectionViewCell

///视频描述
@property (nonatomic, strong) UILabel *videoDescribe;

@property (nonatomic, strong) TalkGridModel *model;
@end
