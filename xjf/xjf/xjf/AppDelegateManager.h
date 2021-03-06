//
//  AppDelegateManager.h
//  xjf
//
//  Created by Hunter_wang on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
typedef enum : NSInteger {
    NetworkUnknown = AFNetworkReachabilityStatusUnknown,
    NetworkDisconnection,
    NetworkWWAN,
    NetworkWIFI,
} NetworkStatus;
@interface AppDelegateManager : NSObject
+ (instancetype)sharedInstance;
- (void)currentDisplayed;
- (NetworkStatus)currentStatus;
@end
