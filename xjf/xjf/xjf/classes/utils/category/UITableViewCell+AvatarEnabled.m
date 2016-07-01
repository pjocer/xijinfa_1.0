//
//  UITableViewCell+AvatarEnabled.m
//  xjf
//
//  Created by PerryJ on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UITableViewCell+AvatarEnabled.h"
#import <objc/runtime.h>
@implementation UITableViewCell (AvatarEnabled)
-(BOOL)avatarEnabled {
    return [objc_getAssociatedObject(self, @selector(avatarEnabled)) boolValue];
}
-(void)setAvatarEnabled:(BOOL)avatarEnabled {
    objc_setAssociatedObject(self, @selector(avatarEnabled), @(avatarEnabled), OBJC_ASSOCIATION_ASSIGN);
}
@end
