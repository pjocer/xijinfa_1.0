//
//  AppDelegate.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <TencentOpenApiSDK/TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "ZPlatformShare.h"
#import "XJMarket.h"
#import "XJAccountManager.h"
#import "Reachability.h"
#import "AlertUtils.h"
#import "SettingViewController.h"
@interface AppDelegate () <WXApiDelegate>
{
    Reachability  *hostReach;
}

@property NetworkStatus remoteHostStatus;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *root = [[RootViewController alloc] init];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    [ZPlatformShare initPlatformData];
    [[XJAccountManager defaultManager] verifyValid];
    
    //
    application.statusBarHidden = NO;
    
    //检测网络状态
    [self appCurrentReachabilityStatus];
    
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[ZPlatformShare sharedInstance] handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation  {
    return [[ZPlatformShare sharedInstance] handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 检查网络状态
- (void)appCurrentReachabilityStatus{
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([hostReach currentReachabilityStatus]) {
        case NotReachable:
            
            NSLog(@"// 没有网络连接");
            break;
        case ReachableViaWWAN:
            
            NSLog(@"// 使用3G网络");
            [AlertUtils alertWithTarget:self.window.rootViewController title:@"提示" content:@"当前为非Wifi, 若想观看视频,请到设置中打开" confirmBlock:^{
            }];
            break;
        case ReachableViaWiFi:
            
            NSLog(@"// 使用WiFi网络");
            break;
    }
    //检查完后， 默认不允许3G/4G网络看视频
    UserDefaultSetObjectForKey(@"NO", USER_SETTING_WIFI);
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [hostReach startNotifier];
}

///reachabilityChanged
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    NSString *netStr;
    if (status == NotReachable) {
        netStr = @"无网络";
    }
    else if (status == ReachableViaWiFi) {
        netStr = @"WIFI";
    }
    else if (status == ReachableViaWWAN) {
        netStr = @"3G/4G ,若想观看视频，请到设置中打开3G/4G";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"当前网络状况为:%@",netStr]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
