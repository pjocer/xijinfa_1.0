//
//  TalkGridModel.m
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TalkGridModel.h"

@implementation TalkGridModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"view"]) {
        _view_ = value;
    }
    if ([key isEqualToString:@"id"]) {
        _id_ = value;
    }
    if ([key isEqualToString:@"video"]) {
        _auto_ = value[@"auto"];
        _view = value[@"view"];
    }
}

@end
