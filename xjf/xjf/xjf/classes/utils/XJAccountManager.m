//
//  XJAccountManager.m
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJAccountManager.h"
#import "RegistFinalModel.h"

@interface XJAccountManager ()
@property(nonatomic, strong) UIAlertView *alertView;
@property(nonatomic, strong) RegistFinalModel *accountFinalModel;
@end

@implementation XJAccountManager

+ (instancetype)defaultManager {
    static XJAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XJAccountManager alloc] initSingle];
    });
    return manager;
}

- (instancetype)initSingle {
    self = [super init];
    if (self) {
        _accountFinalModel = [[RegistFinalModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_INFO] error:nil];
        _user_model = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
        _account_type = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ACCOUNT_TYPE] == nil ? NormalAccount : [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ACCOUNT_TYPE] intValue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenInvalid:) name:TOKEN_INVALID object:nil];
        @weakify(self)
        ReceivedNotification(self, loginSuccess, ^(NSNotification *notification) {
            @strongify(self);
            self.accountFinalModel = notification.object;
            [self getAccountInfo];
        });
    }
    return self;
}

- (void)setAccuontInfo:(NSDictionary *)info {
    self.accountFinalModel = [[RegistFinalModel alloc] initWithDictionary:info error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:ACCOUNT_INFO];
    [[NSUserDefaults standardUserDefaults] setObject:self.accountFinalModel.result.credential.bearer forKey:ACCOUNT_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getAccountInfo];
}

- (void)getAccountInfo {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:user_info RequestMethod:GET];
    NSString *access_token = self.accountFinalModel.result.credential.bearer;
    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        _user_model = [[UserProfileModel alloc] initWithData:responseData error:nil];
        NSDictionary *_user_info = [_user_model toDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:_user_info forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SendNotification(UserInfoDidChangedNotification, _user_model);
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"获取用户信息失败"];
    }];
}

- (NSString *)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ACCESS_TOKEN];
}

- (void)logout {
    NSLog(@"登出");
}

- (void)tokenInvalid:(NSNotification *)notification {
    void (^showAlertBlock)(void) = ^(void) {
        if (self->_alertView) return;
        NSString *message = (NSString *) notification.object;
        self->_alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self->_alertView show];
    };

    if ([NSThread isMainThread]) {
        showAlertBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            showAlertBlock();
        });
    }
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self logout];
    _alertView = nil;
}
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
@end
