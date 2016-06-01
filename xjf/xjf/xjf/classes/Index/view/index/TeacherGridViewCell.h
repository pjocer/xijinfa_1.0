//
//  TeacherGridViewCell.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UzysGridViewCell.h"
#import "TeacherListHostModel.h"
@interface TeacherGridViewCell : UzysGridViewCell
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, strong) TeacherListData *model;
@end
