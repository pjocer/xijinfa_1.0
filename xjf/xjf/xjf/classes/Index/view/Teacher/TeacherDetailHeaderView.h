//
//  TeacherDetailHeaderView.h
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherListHostModel.h"

@interface TeacherDetailHeaderView : UIView
@property (nonatomic, strong) TeacherListData *model;
///关注按钮
@property (nonatomic, strong) UIButton *focusButton;
@end
