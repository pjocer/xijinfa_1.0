//
//  ZPlatformShare.h
//  danpin
//
//  Created by chuangjia on 10/8/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonMarco.h"
#import "XMShareView.h"
#import "XMShareQQUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareWeiboUtil.h"

@interface ZPlatformShare : NSObject
@property (nonatomic, copy) dispatch_block_t success;
@property (nonatomic, copy) dispatch_block_t failed;
+ (instancetype)sharedInstance;
+ (void)initPlatformData;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)shareView:(UIView*)view dict:(NSDictionary*)shareDict;
-(void)shareView:(UIView*)view dict:(NSDictionary*)shareDict type:(NSString*)type;
+ (void)qqLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure;
+ (void)wxLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure;
+ (void)wbLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure;
+ (void)logout;
- (void)weiChatPay:(NSString *)data success:(dispatch_block_t)success failed:(dispatch_block_t)failed;
@end
