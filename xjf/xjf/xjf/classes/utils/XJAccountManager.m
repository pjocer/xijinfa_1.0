//
//  XJAccountManager.m
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJAccountManager.h"
#import "RegistFinalModel.h"
#import "LoginViewController.h"
#import "XJMarket.h"
#import "ZPlatformShare.h"
#import "SDWebImageDownloader.h"
#import <CoreGraphics/CoreGraphics.h>
@interface XJAccountManager ()
@property (nonatomic, strong) RegistFinalModel *accountFinalModel;
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
        [XJMarket sharedMarket];
        _accountFinalModel = [[RegistFinalModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_INFO] error:nil];
        _user_model = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
        _account_type = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ACCOUNT_TYPE] == nil ? NormalAccount : [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ACCOUNT_TYPE] intValue];
        
    }
    return self;
}
- (void)updateUserInfoCompeletionBlock:(void (^)(UserProfileModel *model))compeletionBlock{
    [self getAccountInfo:compeletionBlock];
}

- (BOOL)verifyValid {
    if ([self accessToken] == nil) return YES;
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:verify_user RequestMethod:GET];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            RegistFinalModel *model = [[RegistFinalModel alloc] initWithData:responseData error:nil];
            if (model && model.errCode == 0) {
                NSLog(@"当前AccessToken有效");
            } else {
                UIViewController *controller = getCurrentDisplayController();
                NSString *content = model.errMsg ?: @"登录信息已失效，请重新登录";
                [[ZToastManager ShardInstance] showtoast:content];
                [self logout];
                LoginViewController *vc = [[LoginViewController alloc] init];
                [controller.navigationController pushViewController:vc animated:YES];
            }
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"验证用户信息失败"];
        }];
    });
    return NO;
}

- (void)setUser_model:(UserProfileModel *)user_model {
    _user_model = user_model;
    [self getAccountInfo:^(UserProfileModel *model) {
        NSLog(@"%s",__func__);
    }];
}

- (void)setAccuontInfo:(NSDictionary *)info {
    self.accountFinalModel = [[RegistFinalModel alloc] initWithDictionary:info error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:ACCOUNT_INFO];
    [[NSUserDefaults standardUserDefaults] setObject:self.accountFinalModel.result.credential.bearer forKey:ACCOUNT_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getAccountInfo:nil];
}

- (void)getAccountInfo:(void (^)(UserProfileModel *model))compeletionBlock {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:user_info RequestMethod:GET];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        _user_model = [[UserProfileModel alloc] initWithData:responseData error:nil];
        NSDictionary *_user_info = [_user_model toDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:_user_info forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_user_model.result.avatar] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            UserDefaultSetObjectForKey(data, @"user_icon");
            dispatch_async(dispatch_get_main_queue(), ^{
                SendNotification(UserInfoDidChangedNotification, _user_model);
                if (compeletionBlock) compeletionBlock(_user_model);
            });
        }];
       
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"获取用户信息失败"];
    }];
}

- (NSString *)user_id {
    return self.user_model.result.id;
}

- (NSString *)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ACCESS_TOKEN];
}

//后期加上，清理缓存
- (void)logout {
    _user_model = nil;
    [ZPlatformShare logout];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN_WEIXIN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:OPEN_ID_WEIXIN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN_QQ];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:OPEN_ID_QQ];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCOUNT_INFO];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCOUNT_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SendNotification(UserInfoDidChangedNotification, nil);
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
