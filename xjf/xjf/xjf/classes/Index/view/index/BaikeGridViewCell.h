//
//  BaikeGridViewCell.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UzysGridViewCell.h"
#import "TalkGridModel.h"
@interface BaikeGridViewCell : UzysGridViewCell
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, strong) TalkGridModel *model;
@end
