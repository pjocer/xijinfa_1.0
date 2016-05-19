//
//  asdad.m
//  xjf
//
//  Created by PerryJ on 16/5/17.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFAccountManager.h"
#import "RegistFinalModel.h"

@implementation AccountInfoResultAccountModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation AccountInfoResultModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation AccountInfoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

#pragma mark - Acount Model

static RegistFinalModel *account_final_model;

static AccountInfoModel *account_info_model;


void getAccountInfo(void) {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:user_info RequestMethod:GET];
    NSString *access_token = account_final_model.result.credential.bearer;
    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        account_info_model = [[AccountInfoModel alloc] initWithData:responseData error:nil];
        SendNotification(UserInfoDidChangedNotification, account_info_model);
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"获取用户信息失败"];
    }];
}

@implementation XJFAccountManager

+ (instancetype)sharedAccount {
    static XJFAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XJFAccountManager alloc] init];
    });
    return manager;
}

+ (void)load {
    [super load];
    [[self sharedAccount] registerNotifications];
}

- (void)registerNotifications {
    ReceivedNotification(self, loginSuccess, ^(NSNotification *notification) {
        account_final_model = notification.object;
        getAccountInfo();
    });
}

@end

#pragma mark - Current Display Controller

UIWindow *getCurrentWindow(UIWindow *window) {
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                return tmpWin;
            }
        }
    }
    return window;
}

UIViewController *getAvailableViewController(UIViewController *viewController) {
    UIViewController *result;
    if ([viewController presentedViewController]) {
        UIViewController *controller = viewController.presentedViewController;
        result = getAvailableViewController(controller);
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *) viewController;
        UIViewController *controller = nvc.topViewController;
        result = getAvailableViewController(controller);
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *) viewController;
        UIViewController *controller = tab.selectedViewController;
        result = getAvailableViewController(controller);
    } else {
        result = viewController;
    }
    return result;
}

UIViewController *_Nullable getCurrentDisplayController(void) {
    UIWindow *window = getCurrentWindow([[UIApplication sharedApplication] keyWindow]);
    UIViewController *controller = window.rootViewController;
    UIViewController *vc = getAvailableViewController(controller);
    return vc;
}

#pragma mark Get Current User Info

AccountInfoModel *_Nullable getCurrentUserInfo(void) {
    return account_info_model;
}

#pragma  mark - Get User Access Token

NSString *_Nullable getUserAccessToken(void) {
    return account_final_model.result.credential.bearer;
}


