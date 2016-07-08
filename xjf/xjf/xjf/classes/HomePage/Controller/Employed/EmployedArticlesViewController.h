//
//  EmployedArticlesViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/7/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageBaseViewController.h"

@interface EmployedArticlesViewController : HomePageBaseViewController
typedef NS_OPTIONS(NSInteger, ArticlesType) {
    EmploymentInformation = 0, /*< 从业资讯 >*/
    Guide,                     /*< 报考指南 >*/
    TestTime                   /*< 考试时间 >*/
    
};
@property (nonatomic, assign) ArticlesType articlesType;
@end
