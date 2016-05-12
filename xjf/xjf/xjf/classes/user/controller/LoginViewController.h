//
//  LoginViewController.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDelegate.h"
@interface LoginViewController : BaseViewController
@property (nonatomic,weak) id<UserDelegate> delegate;
@end
