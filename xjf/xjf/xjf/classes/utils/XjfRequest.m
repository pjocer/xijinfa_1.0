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


static NSString *defaultAPIHost = @"http://api.dev.xijinfa.com";

@interface XjfRequest ()
@property (nonatomic, copy) NSString *api_name;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSData *responseData;
@end

@implementation XjfRequest

-(instancetype)initWithAPIName:(nonnull APIName *)apiName RequestMethod:(RequestMethod)method {
    self = [super init];
    if (self) {
        _requestMethod = method;
        _requestParams = [NSMutableDictionary dictionary];
        _requestHeaders = [NSMutableDictionary dictionary];
        if ([apiName rangeOfString:defaultAPIHost].location != NSNotFound) {
            _api_name = apiName;
        }else {
            _api_name = [NSString stringWithFormat:@"%@%@",defaultAPIHost,apiName];
        }
        _manager = [AFHTTPSessionManager manager];
        [self configureRequestHeaders];
    }
    return self;
}
-(void)startWithSuccessBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock {
    switch (self.requestMethod) {
        case POST:
        {
            
            [_manager POST:self.api_name parameters:self.requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self formmatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case GET:
        {
            [_manager GET:self.api_name parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self formmatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock) failedBlock(error);
            }];
        }
            break;
        case PUT:
        {
            [_manager PUT:self.api_name parameters:self.requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self formmatSessionDataTask:response data:responseObject];
                if (successBlock) successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock) failedBlock(error);
            }];
        }
        default:
            break;
    }
}


- (void)formmatSessionDataTask:(NSHTTPURLResponse *)task data:(id)responseObject {
    _responseStatusCode = task.statusCode;
    _responseData = responseObject;
}

-(NSDictionary *)requestHeaders {
    return _manager.requestSerializer.HTTPRequestHeaders;
}

- (void)configureRequestHeaders {
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if ([[XJAccountManager defaultManager] accessToken]) {
        NSString *access_token = [NSString stringWithFormat:@"Bearer %@", [[XJAccountManager defaultManager] accessToken]];
        [_manager.requestSerializer setValue:access_token forHTTPHeaderField:@"Authorization"];
    }
    ReceivedNotification(self, UserInfoDidChangedNotification, ^(NSNotification *notification) {
        [_manager.requestSerializer setValue:[[XJAccountManager defaultManager] accessToken] forHTTPHeaderField:@"Authorization"];
    });
}
-(void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)filed {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:filed];
}
@end
