//  分享工具类基类
//  XMShareUtil.h
//  XMShare
//
//  Created by Amon on 15/8/7.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonMarco.h"

typedef void (^authSuccess)(NSDictionary * message);
typedef void (^authFail)(NSDictionary * message,NSError *error);

@interface XMShareUtil : NSObject


@property(nonatomic,strong) void (^authSuccess)(NSDictionary * message);
@property(nonatomic,strong) void (^authFail)(NSDictionary * message,NSError *error);
/**
 *  分享标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 *  分享内容
 */
@property (nonatomic, strong) NSString *shareText;

/**
 *  分享链接地址
 */
@property (nonatomic, strong) NSString *shareUrl;
//  分享图片
@property (nonatomic, strong) NSString *shareImage;

-(void)openURL:(NSString*)url;
//+(BOOL)isInstalled;
-(void)Auth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)logout;
@end
