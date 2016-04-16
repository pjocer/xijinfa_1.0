//
//  XMShareWeiboUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareWeiboUtil.h"
#import "WBHttpRequest+WeiboUser.h"
#import "WeiboUser.h"


@interface XMShareWeiboUtil ()<WeiboSDKDelegate>
{
    
}
@property(nonatomic,strong)WBAuthorizeRequest *weiboOAth;
@end

@implementation XMShareWeiboUtil

+(BOOL)isInstalled
{
    if ([WeiboSDK isWeiboAppInstalled]) {
        return YES;
    }
    return NO;
}
-(void)Auth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = APP_KEY_WEIBO_RedirectURL;
    authRequest.scope = @"all";
    authRequest.shouldShowWebViewForAuthIfCannotSSO =YES;

    [WeiboSDK sendRequest:authRequest];
    self.authSuccess=success;
    self.authFail=fail;
}
-(void)logout
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    [WeiboSDK logOutWithToken:[user objectForKey:@"access_token"] delegate:nil withTag:nil];
}
-(BOOL)handleOpenURL:(NSURL *)url
{
    if([[url absoluteString] hasPrefix:@"wb"]){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
    return NO;
}

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
        NSLog(@"didReceiveWeiboRequest:%@", request);
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
   NSLog(@"didReceiveWeiboResponse===>%@",response);
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *auRes =(WBAuthorizeResponse*)response;
        
        [WBHttpRequest requestForUserProfile:auRes.userID withAccessToken:auRes.accessToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSLog(@"infoRequest===>%@",result);
            if (error==nil) {
                WeiboUser *user =(WeiboUser *)result;
                
                NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                [dict setValue:[NSString stringWithFormat:@"%@",user.name] forKey:@"nick_name"];
                [dict setValue:[NSString stringWithFormat:@"%@",user.avatarLargeUrl] forKey:@"user_face"];
                [dict setValue:[NSString stringWithFormat:@"%@",user.userID] forKey:@"openId"];
                [dict setValue:[NSString stringWithFormat:@"%@",auRes.accessToken] forKey:@"accessToken"];
                if (self.authSuccess) {
                    self.authSuccess(dict);
                }
            }else{
                if (self.authFail) {
                    self.authFail(nil,error);
                }
            }
        }];
        
    }
    
}


- (void)shareToWeibo
{
    
    [self shareToWeiboBase];
    
}

- (void)shareToWeiboBase
{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = APP_KEY_WEIBO_RedirectURL;
    authRequest.scope = @"all";
    authRequest.shouldShowWebViewForAuthIfCannotSSO =YES;
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString *accesstoken =[user objectForKey:@"access_token"];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:accesstoken];
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;

    
    [WeiboSDK sendRequest:request];

}

- (WBMessageObject *)messageToShare
{
    
    WBMessageObject *message = [WBMessageObject message];
    //
    message.text =[NSString stringWithFormat:@"《%@》",self.shareTitle];
    //
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"com.danpin.www";
    webpage.title = self.shareTitle;
    webpage.description = self.shareText;
    //  可改为自定义图片
    if (self.shareImage.length>0 && ![self.shareImage isEqualToString:@"(null)"]) {
        UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImage]]];
        if(image)
        {
            CGSize size = CGSizeMake(300, 300);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            webpage.thumbnailData = UIImageJPEGRepresentation(newImage, SHARE_IMG_COMPRESSION_QUALITY);
        }
        
    }
    webpage.webpageUrl = self.shareUrl;
    message.mediaObject = webpage;
    return message;
    
}


+ (instancetype)sharedInstance
{
    
    static XMShareWeiboUtil* util;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareWeiboUtil alloc] init];
        
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
    self.weiboOAth=nil;
     NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end