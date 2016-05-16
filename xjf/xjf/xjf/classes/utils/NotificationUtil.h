//
//  NotificationUtil.h
//  QCColumbus
//
//  Created by XuQian on 1/6/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString NotificationName;

/// 普通通知block
typedef void (^NotificationBlock)(NSNotification *notification);

/**
 发送原生通知
 @param name 通知名称
 @param object 通知传参
 */
FOUNDATION_EXTERN void SendNotification(NotificationName *name, id object);

/**
 接收原生通知
 @param target 需要处理通知的宿主对象
 @param name 通知名称
 @param block 通知回调
 */
FOUNDATION_EXTERN id ReceivedNotification(id target, NSString *name, NotificationBlock block);

/**
 根据target对象移除其通知
 @param target 需要移除通知的宿主对象
 */
FOUNDATION_EXTERN void RemoveNotification(id target);

/**
 *  移除所有被记录的通知
 */
FOUNDATION_EXTERN void ClearAllNotifications();

