//
//  CourseGridViewCell.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UzysGridViewCell.h"
#import "ProjectListByModel.h"

@interface CourseGridViewCell : UzysGridViewCell
@property(nonatomic, retain) UIView *backgroundView;
@property(nonatomic, strong) ProjectList *model;
@end
