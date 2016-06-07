//
//  LessonDetailLessonListCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"
@interface LessonDetailLessonListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *studyImage;
@property (nonatomic, strong) TalkGridModel *talkGridModel;
@property (nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *freeVideoLogo;
@property(nonatomic, strong) UIImageView *favorites;
@end
