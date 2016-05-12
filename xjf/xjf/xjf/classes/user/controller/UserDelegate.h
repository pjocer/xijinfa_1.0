//
//  UserDelegate.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDelegate <NSObject>
@optional
- (void)userLoginOK:(id)userinfo;
- (void)userLoginFail;
- (void)userDidCancel;

- (void)userRegistOK:(id)userInfo;
- (void)userRegistFail;

@end