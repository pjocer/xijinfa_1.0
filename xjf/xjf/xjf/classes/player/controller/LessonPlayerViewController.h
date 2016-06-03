//
//  LessonPlayerViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerBaseViewController.h"
#import "LessonDetailListModel.h"
@interface LessonPlayerViewController : PlayerBaseViewController
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) LessonDetailListModel *lessonDetailListModel;
@property (nonatomic, strong) NSString *lesssonID;
@end
