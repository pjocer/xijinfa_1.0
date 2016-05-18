//
//  VideoListCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"
@interface VideoListCell : UITableViewCell
@property (nonatomic, strong) TalkGridModel *model;

///主讲老师
@property (nonatomic, strong) UILabel *teacherName;
///课时
@property (nonatomic, strong) UILabel *lessonCount;
///现在价格
@property (nonatomic, strong) UILabel *price;
///之前前个
@property (nonatomic, strong) UILabel *oldPrice;
@end
