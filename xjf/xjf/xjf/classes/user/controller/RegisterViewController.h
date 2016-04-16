//
//  RegisterViewController.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDelegate.h"
@interface RegisterViewController : BaseViewController
+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithDelegate:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithDelegate:]")));

+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate;
@end
