//
//  AppDelegateManager.m
//  xjf
//
//  Created by Hunter_wang on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AppDelegateManager.h"
#import "XJAccountManager.h"
#import "SettingViewController.h"
#import "ZPlatformShare.h"

@interface AppDelegateManager () {
    NetworkStatus _currentStatus;
}
@end

@implementation AppDelegateManager
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppDelegateManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[AppDelegateManager alloc] _init];
    });
    return manager;
}
- (instancetype)_init {
    self = [super init];
    if (self) {
        [self initControl];
    }
    return self;
}
- (void)initControl {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self startMonitoringAppCurrentNetworkReachabilityStatus];
    [ZPlatformShare initPlatformData];
    [[XJAccountManager defaultManager] verifyValid];
//    [self rac]
}
//网络状态
- (void)startMonitoringAppCurrentNetworkReachabilityStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _currentStatus = (NetworkStatus)status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [AlertUtils alertWithTarget:getCurrentDisplayController() title:@"提示" content:@"当前为非Wifi, 若想观看视频,请到设置中打开" confirmBlock:^{
                    UIViewController *currentViewController = getCurrentDisplayController();
                    [currentViewController.navigationController pushViewController:[SettingViewController new] animated:YES];
                }];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:

                break;
        }
    }];
    [manager startMonitoring];
}
-(NetworkStatus)currentStatus {
    return _currentStatus;
}
-(void)currentDisplayed {
    
}
@end
