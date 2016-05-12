//
//  RegistViewController.h
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//
#import "BaseViewController.h"
#import "UserDelegate.h"
@interface RegistViewController : BaseViewController

@property (nonatomic, weak)id <UserDelegate>delegate;
@property (nonatomic, copy) NSString *title_item;
+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate;
@end




