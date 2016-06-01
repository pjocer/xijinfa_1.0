//
//  BaseViewController.h
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xjfConfigure.h"
#import "Masonry.h"
#import "BaseViewCell.h"
#import "ZToastManager.h"

//为首界面设置HeaderView
FOUNDATION_EXTERN NSString *const Index;
FOUNDATION_EXTERN NSString *const My;
FOUNDATION_EXTERN NSString *const Topic;
FOUNDATION_EXTERN NSString *const Vip;
FOUNDATION_EXTERN NSString *const Subscribe;

@interface BaseViewController : UIViewController

@property (nonatomic, assign) NSUInteger topicTag;

@property (nonatomic, copy) NSString *nav_title;

- (void)extendheadViewFor:(NSString *)name;

@end
