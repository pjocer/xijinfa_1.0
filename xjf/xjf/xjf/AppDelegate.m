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
#import "AppDelegateManager.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *root = [[RootViewController alloc] init];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    [AppDelegateManager sharedInstance];
    return YES;
}
 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[ZPlatformShare sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[ZPlatformShare sharedInstance] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // onPause
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // onStop
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // onRestart
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // onResume
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // onDestroy
}

@end
