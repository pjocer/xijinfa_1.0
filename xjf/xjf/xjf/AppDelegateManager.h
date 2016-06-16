//
//  AppDelegateManager.h
//  xjf
//
//  Created by Hunter_wang on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDelegateManager : NSObject

///开始监听当前网络状态
+ (void)startMonitoringAppCurrentNetworkReachabilityStatus;

@end
