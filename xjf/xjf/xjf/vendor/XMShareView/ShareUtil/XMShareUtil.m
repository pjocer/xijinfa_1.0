//
//  XMShareUtil.m
//  XMShare
//
//  Created by Amon on 15/8/7.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareUtil.h"
@implementation XMShareUtil

-(void)setAuthSuccess:(void (^)(NSDictionary *))authSuccess
{
   _authSuccess =authSuccess;
}
-(void)setAuthFail:(void (^)(NSDictionary *, NSError *))authFail
{
    _authFail =authFail;
}

+(BOOL)isInstalled
{
    return NO;
}
-(void)Auth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail
{
    
}
-(void)openURL:(NSString*)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}
-(void)logout
{
    
}
@end
