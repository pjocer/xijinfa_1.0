//
//  NotificationUtil.h
//  QCColumbus
//
//  Created by XuQian on 1/6/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 通知所属，行程相关，费用相关或审批相关
typedef NS_OPTIONS(ushort, UpdateCategory) {
    /// 更新申请单
    ApplyUpdate,
    /// 更新费用
    CostUpdate,
    /// 更新报销单
    ExpenseUpdate,
    /// 更新审批操作
    ReimbursementUpdate,
    /// 更新日程
    DailyReportUpdate,
    /// 更新签到
    CheckinUpdate,
    /// 主动刷新界面
    AutomaticUpdate,
};

/// 操作类型
typedef NS_OPTIONS(ushort, UpdateType) {
    Add = 1,
    Edit,
    Delete,
    Move,
    CostType,
    Agree,
    Reject,
    Revoke,
    AddSign,
};

/// 普通通知block
typedef void (^NotificationBlock)(NSNotification *notification);

/// 消息类通知block
typedef void (^UpdateNotificationBlock)(UpdateCategory category, UpdateType type, id object);

/**
 发送原生通知
 @param name 通知名称
 @param object 通知传参
 */
FOUNDATION_EXTERN void SendNotification(NSString *name, id object);

/**
 发送消息类通知
 @param category 消息类型
 @param type 操作类型
 @param object 通知传参
 */
FOUNDATION_EXTERN void SendUpdateNotification(UpdateCategory category, UpdateType type, id object);

/**
 接收原生通知
 @param target 需要处理通知的宿主对象
 @param name 通知名称
 @param block 通知回调
 */
FOUNDATION_EXTERN id ReceivedNotification(id target, NSString *name, NotificationBlock block);

/**
 接收消息类通知
 @param target 需要处理通知的宿主对象
 @param block 通知回调
 */
FOUNDATION_EXTERN id ReceivedUpdateNotification(id target, UpdateNotificationBlock block);

/**
 根据target对象移除其通知
 @param target 需要移除通知的宿主对象
 */
FOUNDATION_EXTERN void RemoveNotification(id target);

/**
 *  移除所有被记录的通知
 */
FOUNDATION_EXTERN void ClearAllNotifications();

