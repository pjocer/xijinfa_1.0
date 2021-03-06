//
//  NotificationUtil.m
//  QCColumbus
//
//  Created by XuQian on 1/6/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import "NotificationUtil.h"

NSString *const UpdateInfoNotification = @"UpdateInfoNotification";

static NSMutableDictionary *__notification_targets;

void SendNotification(NSString *name, id object) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

id ReceivedNotification(id target, NotificationName *name, NotificationBlock block) {
    if (!target) return nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __notification_targets = [NSMutableDictionary dictionary];
    });
    __weak id notification = [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue currentQueue] usingBlock:block];
    NSString *key = NSStringFromClass([target class]);
    NSMutableArray *array = __notification_targets[key] ?: [NSMutableArray array];
    [array addObject:notification];
    [__notification_targets setObject:array forKey:key];
    return notification;
}

void RemoveNotification(id target) {
    if (!target || !__notification_targets) return;

    NSString *key = NSStringFromClass([target class]);
    NSArray *array = __notification_targets[key];
    if (array) {
        for (id object in array) {
            [[NSNotificationCenter defaultCenter] removeObserver:object];
        }
        [__notification_targets removeObjectForKey:key];
    }
}

void ClearAllNotifications() {
    if (!__notification_targets) return;

    for (NSArray *array in __notification_targets.allValues) {
        for (id object in array) {
            [[NSNotificationCenter defaultCenter] removeObserver:object];
        }
    }
    [__notification_targets removeAllObjects];
}
