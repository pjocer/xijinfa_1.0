//
//  PlayerPageDescribeHeaderView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonDetailListModel.h"

@interface PlayerPageDescribeHeaderView : UIView
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *thumbUpButton;
@property (nonatomic, strong) LessonDetailListResultModel *model;
@end
