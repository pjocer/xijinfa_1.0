//
//  TeacherDescriptionViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface TeacherDescriptionViewController : BaseViewController
@property (nonatomic, strong) NSString *tempContent;
@property (nonatomic, strong) UIWebView *web;
@end
