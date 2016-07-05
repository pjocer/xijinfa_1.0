//
//  PlayerPageDescribeCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"
#import "LessonDetailListModel.h"

@interface PlayerPageDescribeCell : UICollectionViewCell
///标题
@property (nonatomic, strong) UILabel *title;
///视频描述
@property (nonatomic, strong) UILabel *videoDescribe;
///播放次数 及 视频类型
@property (nonatomic, strong) UILabel *titleDetail;
///展示描述视频按钮
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) TalkGridModel *model;
@property (nonatomic, strong) LessonDetailListResultModel *lessonDetailListResultModel;
@property (nonatomic, assign) BOOL isShowVideDescrible;
@end
