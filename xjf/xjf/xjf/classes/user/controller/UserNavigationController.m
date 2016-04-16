//
//  UserNavigationController.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserNavigationController.h"
#import "LoginViewController.h"
@interface UserNavigationController ()

@end

@implementation UserNavigationController

+ (instancetype)newWithCameraDelegate:(id<UserDelegate>)delegate
{
    UserNavigationController *navigationController = [super new];
    navigationController.navigationBarHidden = YES;
    if (navigationController) {
        [navigationController setupAuthorizedWithDelegate:delegate];
    }
    
    return navigationController;
}
- (void)setupAuthorizedWithDelegate:(id<UserDelegate>)delegate
{
    LoginViewController *viewController = [LoginViewController new];
    viewController.delegate = delegate;
    self.viewControllers = @[viewController];
}

@end