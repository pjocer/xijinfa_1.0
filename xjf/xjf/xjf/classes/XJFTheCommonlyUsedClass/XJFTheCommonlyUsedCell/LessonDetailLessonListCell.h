//
//  LessonDetailLessonListCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"

@class LessonDetailLessonListCell;

@protocol LessonDetailLessonListCellDelegate <NSObject>
- (void)lessonDetailLessonListCell:(LessonDetailLessonListCell *)cell PriceButtonPushOrderDetail:(TalkGridModel *)selectModel;
@end

@interface LessonDetailLessonListCell : UITableViewCell
@property (nonatomic, strong) UIButton *shop;
@property (nonatomic, strong) TalkGridModel *talkGridModel;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *favorites;
@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, strong) UIButton *lessonPrice;
@property (nonatomic, assign) id <LessonDetailLessonListCellDelegate> delegate;
@end
