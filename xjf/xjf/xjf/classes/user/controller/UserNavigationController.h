//
//  UserNavigationController.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDelegate.h"

@interface UserNavigationController : UINavigationController
+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithCameraDelegate:]")));

- (id)initWithCoder:(NSCoder *)aDecoder __attribute__
((unavailable("[-initWithCoder:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass __attribute__
((unavailable("[-initWithNavigationBarClass:toolbarClass:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__
((unavailable("[-initWithNibName:bundle:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController __attribute__
((unavailable("[-initWithRootViewController:] is not allowed, use [+newWithCameraDelegate:]")));

+ (instancetype)newWithCameraDelegate:(id<UserDelegate>)delegate;

@end