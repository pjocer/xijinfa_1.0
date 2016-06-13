//
//  LessonPlayerVideoBottomView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"
@class LessonPlayerVideoBottomView;

@protocol LessonPlayerVideoBottomViewDelegate <NSObject>
- (void)LessonPlayerVideoBottomView:(LessonPlayerVideoBottomView *)sender DidDownloadOrCollectionButton:(UIButton *)button;
@end

@interface LessonPlayerVideoBottomView : UIView
@property (nonatomic, strong) TalkGridModel *model;
@property (nonatomic, strong) UIButton *download;
@property (nonatomic, strong) UIButton *collection;
@property (nonatomic, strong) UIButton *collectionLogo;
@property (nonatomic, strong) UILabel *collectionCount;
@property (nonatomic, assign) id<LessonPlayerVideoBottomViewDelegate>delegate;
@end
