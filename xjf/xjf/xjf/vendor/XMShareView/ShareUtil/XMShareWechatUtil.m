//
//  XMShareWechatUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareWechatUtil.h"
#import "WXApi.h"
@interface XMShareWechatUtil()<WXApiDelegate>
{
    
}
@end
@implementation XMShareWechatUtil

+(BOOL)isInstalled
{
    if([WXApi isWXAppInstalled])
    {
        return YES;
    }
    return NO;
}
-(void)Auth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"Weixinauth";
    [WXApi sendReq:req];
    self.authSuccess=success;
    self.authFail=fail;
    
}
-(BOOL)handleOpenURL:(NSURL *)url
{
    if([[url absoluteString] hasPrefix:@"wx"]){
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    return NO;
}
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAppID,kWXAppKey,code];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL *zoneUrl = [NSURL URLWithString:url];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                if (data==nil || ![data isKindOfClass:[NSData class]]) {
                    if (self.authFail) {
                        self.authFail(nil,nil);
                    }
                    return ;
                }
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //
                NSString *access_token =[dic objectForKey:@"access_token"];
                NSString *openid =[dic objectForKey:@"openid"];
                NSString *uurl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
                NSURL *uzoneUrl = [NSURL URLWithString:uurl];
                NSString *uzoneStr = [NSString stringWithContentsOfURL:uzoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *udata = [uzoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (udata) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:udata options:NSJSONReadingMutableContainers error:nil];
                        NSMutableDictionary *dict  =[NSMutableDictionary dictionaryWithDictionary:dic];
                        [dict setValue:access_token forKey:@"accessToken"];
                        NSLog(@"onResp===>%@",dic);
                        if (self.authSuccess) {
                            self.authSuccess(dict);
                        }
                        
                    }else{
                        if (self.authFail) {
                            self.authFail(nil,nil);
                        }
                    }
                });
            });
            
        }else{
            if (self.authFail) {
                self.authFail(nil,nil);
            }
        }
        
    }
    
}
- (void)shareToWeixinSession
{
    
    [self shareToWeixinBase:WXSceneSession];
    
}

- (void)shareToWeixinTimeline
{
    
    [self shareToWeixinBase:WXSceneTimeline];
    
}

- (void)shareToWeixinBase:(enum WXScene)scene
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareText;
    if (self.shareImage.length>0 && ![self.shareImage isEqualToString:@"(null)"]) {
        UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImage]]];
        if(image)
        {
            CGSize size = CGSizeMake(300, 300);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
           [message setThumbData:UIImageJPEGRepresentation(newImage, SHARE_IMG_COMPRESSION_QUALITY)];
        }
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.shareUrl;
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
}


+ (instancetype)sharedInstance
{
    
    static XMShareWechatUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareWechatUtil alloc] init];
        
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


@end
