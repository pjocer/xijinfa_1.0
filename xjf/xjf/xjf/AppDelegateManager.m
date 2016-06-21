//
//  AppDelegateManager.m
//  xjf
//
//  Created by Hunter_wang on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AppDelegateManager.h"
#import <AFNetworking/AFNetworking.h>
#import "XJAccountManager.h"
#import "SettingViewController.h"
#import "ZPlatformShare.h"

@interface AppDelegateManager ()
@end

@implementation AppDelegateManager
+ (void)initControl {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self startMonitoringAppCurrentNetworkReachabilityStatus];
    [ZPlatformShare initPlatformData];
    [[XJAccountManager defaultManager] verifyValid];
}
//网络状态
+ (void)startMonitoringAppCurrentNetworkReachabilityStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [AlertUtils alertWithTarget:getCurrentDisplayController() title:@"提示" content:@"当前为非Wifi, 若想观看视频,请到设置中打开" confirmBlock:^{
                    UIViewController *currentViewController = getCurrentDisplayController();
                    [currentViewController.navigationController pushViewController:[SettingViewController new] animated:YES];
                }];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:

                break;
        }
    }];
    [manager startMonitoring];
}
@end
