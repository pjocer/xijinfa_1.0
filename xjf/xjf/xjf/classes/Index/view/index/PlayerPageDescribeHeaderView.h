//
//  PlayerPageDescribeHeaderView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerPageDescribeHeaderView : UICollectionReusableView

///下载
@property (nonatomic, strong) UIButton *downLoadButton;
///分享
@property (nonatomic, strong) UIButton *shareButton;
///收藏
@property (nonatomic, strong) UIButton *collectionButton;
///标题
@property (nonatomic, strong) UILabel *title;
///播放次数 及 视频类型
@property (nonatomic, strong) UILabel *titleDetail;
///展示描述视频按钮
@property (nonatomic, strong) UIButton *rightButton;
@end
