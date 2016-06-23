//
//  PlayerViewController.h
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//
#import "PlayerBaseViewController.h"
#import "TalkGridModel.h"
#import "ZFPlayer.h"
#import "ZFPlayerView+Category.h"

@interface PlayerViewController : PlayerBaseViewController
@property (nonatomic, retain) TalkGridModel *talkGridModel;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) TablkListModel *talkGridListModel;
@end
