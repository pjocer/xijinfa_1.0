//
//  ZPlatformShare.m
//  danpin
//
//  Created by chuangjia on 10/8/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import "ZPlatformShare.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "xjfConfigure.h"
#import "MyLessonsViewController.h"
#import "XJMarket.h"
#import "Order.h"



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
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            BOOL isSuccess = [self parseResult:resultDic];
            if (isSuccess) {
                SendNotification(PayLessonsSuccess,nil);
            } else {
                NSLog(@"支付失败 type:2");
            }
        }];
    }
    
    return NO;
}

- (BOOL)parseResult:(NSDictionary *)result {
    NSString *resultSting = result[@"result"];
    BOOL codeIsOK;
    BOOL SuccessIsOk;
    BOOL signIsOK;
    if ([result[@"resultStatus"] isEqualToString:@"9000"]) {
        codeIsOK = YES;
    } else {
        return NO;
    }
    NSArray *resultStringArray =[resultSting componentsSeparatedByString:NSLocalizedString(@"&", nil)];
    for (NSString *str in resultStringArray)
    {
        NSString *newstring = nil;
        newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
        for (int i = 0 ; i < [strArray count] ; i++)
        {
            NSString *st = [strArray objectAtIndex:i];
            if ([st isEqualToString:@"success"])
            {
                if ([[strArray objectAtIndex:1] isEqualToString:@"true"]) {
                    SuccessIsOk = YES;
                }else {
                    return NO;
                }
            }
            if ([st isEqualToString:@"sign"]) {
                if ([strArray objectAtIndex:1]!=nil) {
                    signIsOK = YES;
                }else {
                    return NO;
                }
            }
        }
    }
    return YES;
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
-(void)weiChatPay:(NSString *)data success:(dispatch_block_t)success failed:(dispatch_block_t)failed {
    self.success = success;
    self.failed = failed;
    PaymentData *data_payment = [[PaymentData alloc]initWithString:data usingEncoding:NSUTF8StringEncoding error:nil];
    PayReq *req = [[PayReq alloc]init];
    req.package = data_payment.package;
    req.partnerId = data_payment.partnerid;
    req.prepayId = data_payment.prepayid;
    req.nonceStr = data_payment.noncestr;
    req.timeStamp = data_payment.timestamp;
    req.sign = data_payment.sign;
    [WXApi sendReq:req];
}
@end
