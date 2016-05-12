//
//  NotificationUtil.m
//  QCColumbus
//
//  Created by XuQian on 1/6/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import "NotificationUtil.h"

NSString * const UpdateInfoNotification = @"UpdateInfoNotification";

static NSMutableDictionary *__notification_targets;

void SendNotification(NSString *name, id object)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

void SendUpdateNotification(UpdateCategory category, UpdateType type, id object)
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"category":[NSNumber numberWithInt:category], @"type":[NSNumber numberWithInt:type]}];
    if (object) [dictionary setObject:object forKey:@"object"];
    SendNotification(UpdateInfoNotification, dictionary);
}

id ReceivedNotification(id target, NSString *name, NotificationBlock block)
{
    if (!target) return nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __notification_targets = [NSMutableDictionary dictionary];
    });
    
    __weak id notification = [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue currentQueue] usingBlock:block];
    
    NSString *key = NSStringFromClass([target class]);
    NSMutableArray *array = __notification_targets[key]?:[NSMutableArray array];
    [array addObject:notification];
    [__notification_targets setObject:array forKey:key];
    
    return notification;
}

id ReceivedUpdateNotification(id target, UpdateNotificationBlock block)
{
    return ReceivedNotification(target, UpdateInfoNotification, ^(NSNotification *notification) {
        NSDictionary *infoObject = notification.object;
        if (block) block((UpdateCategory)[infoObject[@"category"] intValue],
                         (UpdateType)[infoObject[@"type"] intValue],
                         infoObject[@"object"]);
    });
}

void RemoveNotification(id target)
{
    if (!target || !__notification_targets) return;
    
    NSString *key = NSStringFromClass([target class]);
    NSArray *array = __notification_targets[key];
    for (id object in array) {
        [[NSNotificationCenter defaultCenter] removeObserver:object];
    }
    [__notification_targets removeObjectForKey:key];
}

void ClearAllNotifications()
{
    if (!__notification_targets) return;
    
    for (NSArray *array in __notification_targets.allValues) {
        for (id object in array) {
            [[NSNotificationCenter defaultCenter] removeObserver:object];
        }
    }
    [__notification_targets removeAllObjects];
}
