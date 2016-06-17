//
//  EmployedLessonListViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexBaseViewController.h"

@interface EmployedLessonListViewController : IndexBaseViewController
///基础知识ID
@property (nonatomic, strong) NSString *employedBasisID;
///法律法规ID
@property (nonatomic, strong) NSString *employedLawsID;
///全科ID
@property (nonatomic, strong) NSString *employedGeneralID;
@property (nonatomic, strong) NSString *employedLessonList;
@end
