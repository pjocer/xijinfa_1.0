//
//  PasswordSettingViewController.h
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDelegate.h"
@interface PasswordSettingViewController : BaseViewController
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, weak)id <UserDelegate>delegate;
@end
