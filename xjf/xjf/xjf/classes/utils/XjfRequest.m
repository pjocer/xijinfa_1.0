//
//  XjfRequest.m
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XjfRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import "XJAccountManager.h"
#import "ZToastManager.h"


@interface XjfRequest ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *api_name;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation XjfRequest

- (instancetype)initWithAPIName:(nonnull APIName *)apiName RequestMethod:(RequestMethod)method {
    self = [super init];
    if (self) {
        NSParameterAssert(apiName);
        _requestMethod = method;
        _requestParams = [NSMutableDictionary dictionary];
        _requestHeaders = [NSMutableDictionary dictionary];
        if ([apiName rangeOfString:HttpBaseURL].location != NSNotFound) {
            _api_name = apiName;
        } else {
            _api_name = [NSString stringWithFormat:@"%@%@", HttpBaseURL, apiName];
        }
        _api_name = [_api_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _manager = [AFHTTPSessionManager manager];
        [self configureRequestHeaders];
    }
    return self;
}

- (instancetype)initWithAPIName:(APIName *)apiName fileURL:(nullable NSURL *)url {
    self = [self initWithAPIName:apiName RequestMethod:UPLOAD];
    if (self) {
        NSParameterAssert(apiName);
        _url = url;
    }
    return self;
}

- (void)startWithSuccessBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZToastManager ShardInstance] showprogress];
    });
    switch (self.requestMethod) {
        case POST: {
            [_manager POST:self.api_name parameters:self.requestParams progress:^(NSProgress *_Nonnull uploadProgress) {

            }      success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                });
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            }      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                    [[ZToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"网络连接失败 错误码(%ld)",_responseStatusCode]];
                });
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case GET: {
            [_manager GET:self.api_name parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {

            }     success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                });
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                    [[ZToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"网络连接失败 错误码(%ld)",_responseStatusCode]];
                });
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case PUT: {
            [_manager PUT:self.api_name parameters:self.requestParams success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                });
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                    [[ZToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"网络连接失败 错误码(%ld)",_responseStatusCode]];
                });
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case DELETE: {
            [_manager DELETE:self.api_name parameters:self.requestParams success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                });
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            }        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZToastManager ShardInstance] hideprogress];
                    [[ZToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"网络连接失败 错误码(%ld)",_responseStatusCode]];
                });
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case UPLOAD: {
            __block MBProgressHUD *hud = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZToastManager ShardInstance] hideprogress];
                UIViewController *controller = getCurrentDisplayController();
                hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
                hud.mode = MBProgressHUDModeDeterminate;
                hud.labelText = @"正在上传头像";
            });
            [_manager POST:_api_name parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
                if (_url) {
                    NSError *error = nil;
                    [formData appendPartWithFileURL:_url name:@"avatar" error:&error];
                    return;
                }
                if (_fileData) {
                    [formData appendPartWithFormData:_fileData name:@"avatar"];
                    return;
                }
                
            }     progress:^(NSProgress *_Nonnull uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.progress = uploadProgress.fractionCompleted;
                });
            }      success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:responseObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                });
                if (_responseStatusCode == 200) {
                    if (successBlock) successBlock(responseObject);
                } else {
                    if (failedBlock) failedBlock(nil);
                }
            }      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
                [self formatSessionDataTask:response data:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [[ZToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"网络连接失败 错误码(%ld)",_responseStatusCode]];
                });
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)formatSessionDataTask:(NSHTTPURLResponse *)task data:(id)responseObject {
    _responseStatusCode = task.statusCode;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *result = responseDic[@"result"];
    
}

- (NSDictionary *)requestHeaders {
    return _manager.requestSerializer.HTTPRequestHeaders;
}

- (void)configureRequestHeaders {
    if (self.requestMethod == UPLOAD) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if ([[XJAccountManager defaultManager] accessToken]) {
        NSString *access_token = [NSString stringWithFormat:@"Bearer %@", [[XJAccountManager defaultManager] accessToken]];
        [_manager.requestSerializer setValue:access_token forHTTPHeaderField:@"Authorization"];
    }
    ReceivedNotification(self, UserInfoDidChangedNotification, ^(NSNotification *notification) {
        [_manager.requestSerializer setValue:[[XJAccountManager defaultManager] accessToken] forHTTPHeaderField:@"Authorization"];
    });
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)filed {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:filed];
}

@end
