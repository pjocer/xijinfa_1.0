//
//  XMShareQQUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareQQUtil.h"
#import "xjfConfigure.h"
@interface XMShareQQUtil () <TencentSessionDelegate>
{
    
}
@property(nonatomic,strong)TencentOAuth *tencentOAuth ;
@end

@implementation XMShareQQUtil
+(BOOL)isInstalled
{
    if ([TencentOAuth iphoneQQInstalled]) {
        return YES;
    }
    return NO;
}
-(void)Auth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail
{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
    DLog(@"TencentOAuth accessToken:%@", _tencentOAuth.accessToken);
    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [_tencentOAuth authorize:_permissions];
    self.authSuccess=success;
    self.authFail=fail;
}
-(void)logout
{
    if (_tencentOAuth) {
        [_tencentOAuth logout:nil];
    }
}
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    DLog(@"tencentDidLogin:%@-", _tencentOAuth.accessToken);
    [_tencentOAuth getUserInfo];
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:response.jsonResponse];
    [dict setValue:_tencentOAuth.openId forKey:@"openId"];
    [dict setValue:_tencentOAuth.accessToken forKey:@"accessToken"];
    if (self.authSuccess) {
        self.authSuccess(dict);
    }

     DLog(@"respons:%@",dict);
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (self.authFail) {
        self.authFail(nil,nil);
    }
    
     DLog(@"tencentDidNotLogin:%@", _tencentOAuth.accessToken);
}
-(BOOL)handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }
    return NO;
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
     DLog(@"tencentDidNotNetWork:%@", _tencentOAuth.accessToken);
}
- (void)shareToQQ
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_SESSION];
    
}

- (void)shareToQzone
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_QZONE];
    
}

- (void)shareToQQBase:(SHARE_QQ_TYPE)type
{
    
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
    DLog(@"TencentOAuth accessToken:%@", tencentOAuth.accessToken);
    
    NSString *utf8String = self.shareUrl;
    NSString *theTitle = self.shareTitle;
    NSString *description = self.shareText;
//    UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImage]]];
//    NSData *imageData = UIImageJPEGRepresentation(image, SHARE_IMG_COMPRESSION_QUALITY);
//    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:theTitle
                                description:description
                                previewImageURL:[NSURL URLWithString:self.shareImage]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (type == SHARE_QQ_TYPE_SESSION) {
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        DLog(@"QQApiSendResultCode:%d", sent);
        
    }else{
        
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        DLog(@"Qzone QQApiSendResultCode:%d", sent);
        
    }
}


+ (instancetype)sharedInstance
{
    
    static XMShareQQUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareQQUtil alloc] init];
        
    });
    return util;
    
}

- (instancetype)init
{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        obj = [super init];
        
        if (obj) {
            
        }
    });
    self=obj;
    return self;
}
-(void)dealloc
{
    self.tencentOAuth=nil;
    DLog(@"%s", __PRETTY_FUNCTION__);
}
@end
