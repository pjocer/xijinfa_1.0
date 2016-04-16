//
//  UserThirdLogin.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDelegate.h"
@interface UserThirdLogin : BaseViewController
+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithDelegate:userinfo:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithDelegate:userinfo:]")));

+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate userinfo:(NSDictionary*)userinfo;

@end
