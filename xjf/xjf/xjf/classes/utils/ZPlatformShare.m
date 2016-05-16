//
//  ZPlatformShare.m
//  danpin
//
//  Created by chuangjia on 10/8/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import "ZPlatformShare.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "xjfConfigure.h"
@interface ZPlatformShare()
{
    
}
@property(nonatomic,strong)NSDictionary *shareDictionary;

@end
@implementation ZPlatformShare
@synthesize shareDictionary=_shareDictionary;
+ (instancetype)sharedInstance
{
    static ZPlatformShare *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZPlatformShare alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
       
    }
    return self;
}
-(void)dealloc
{
}
+ (void)initPlatformData
{
    
   [WXApi registerApp:APP_KEY_WEIXIN withDescription:@"Wechat"];
//   BOOL wb=  [WeiboSDK registerApp:APP_KEY_WEIBO];
//  DLog(@"--WXApi--%d-----WeiboSDK-%d",wx,wb);
    
}
-(BOOL)handleOpenURL:(NSURL *)url
{

    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [[XMShareQQUtil sharedInstance] handleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]){
        
        return [[XMShareWeiboUtil sharedInstance] handleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wx"]){
        
        return [[XMShareWechatUtil sharedInstance] handleOpenURL:url];
        
    }
    return NO;
}

//分享
-(void)shareView:(UIView*)view dict:(NSDictionary*)shareDict
{
    [self shareView:view dict:shareDict type:@""];
}
-(void)shareView:(UIView*)view dict:(NSDictionary*)shareDict type:(NSString*)type
{
    
    XMShareView *shareView = [[XMShareView alloc] initWithFrame:view.bounds type:type];
    shareView.shareTitle=[NSString stringWithFormat:@"%@",[shareDict objectForKey:@"info"]];
    shareView.shareTitle=[NSString stringWithFormat:@"%@",[shareDict objectForKey:@"title"]];
    shareView.shareText =[NSString stringWithFormat:@"%@",[shareDict objectForKey:@"desc"]];
    NSString *urlstr =[NSString stringWithFormat:@"%@",[shareDict objectForKey:@"url"]];
    NSRange foundObj=[urlstr rangeOfString:@"?" options:NSCaseInsensitiveSearch];
//    if(foundObj.length>0) {
//        shareView.shareUrl=[NSString stringWithFormat:@"%@&share_code=%@",urlstr,[ZShare sharedInstance].sharecode_key];
//    } else {
//        shareView.shareUrl=[NSString stringWithFormat:@"%@?share_code=%@",urlstr,[ZShare sharedInstance].sharecode_key];
//    }
    NSString *iurl =[NSString stringWithFormat:@"%@",[shareDict objectForKey:@"image"]];
    shareView.shareImage =iurl;
    [view addSubview:shareView];
    shareView=nil;
    
}
+ (void)qqLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure
{
    [[XMShareQQUtil sharedInstance] Auth:@"" Success:^(NSDictionary *message) {
        success(message);
    } Fail:^(NSDictionary *message, NSError *error) {
        failure(message,error);
    }];
}
+ (void)wxLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure
{
    [[XMShareWechatUtil sharedInstance] Auth:@"" Success:^(NSDictionary *message) {
         success(message);
    } Fail:^(NSDictionary *message, NSError *error) {
           failure(message,error);
    }];
}
+ (void)wbLoginWithSuccess:(void(^)(NSDictionary *message))success failure:(void(^)(NSDictionary *message, NSError *error))failure
{
    [[XMShareWeiboUtil sharedInstance] Auth:@"" Success:^(NSDictionary *message) {
        success(message);
    } Fail:^(NSDictionary *message, NSError *error) {
        failure(message,error);
    }];
}
+ (void)logout
{
    [[XMShareQQUtil sharedInstance] logout];
    [[XMShareWechatUtil sharedInstance] logout];
    [[XMShareWeiboUtil sharedInstance] logout];
}
+ (NSString *)WeiChatPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}
@end
