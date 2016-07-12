//
//  XJRequest.h
//  xjf
//
//  Created by PerryJ on 16/7/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XjfRequest.h"

@class XJRequest;
/**
 *  请求成功
 *
 *  @param request XJRequest Instance
 */
typedef void(^Success)(XJRequest *request);
/**
 *  请求失败
 *
 *  @param request XJRequest Instance
 */
typedef void(^Failed)(XJRequest *request);
/**
 *  请求参数,没有则忽略
 *
 *  @return 参数信息
 */
typedef NSDictionary *(^Params)();

@interface XJRequest : XjfRequest
/**
 *  错误状态码
 */
@property (nonatomic, assign) NSInteger errCode;
/**
 *  错误信息
 */
@property (nonatomic, copy) NSString *errMsg;
/**
 *  请求成功时的返回信息
 */
@property (nonatomic, strong) NSDictionary *result;
/**
 *  请求失败时的返回信息
 */
@property (nonatomic, strong) NSError *requestError;
/**
 *  静态方法进行网络请求
 *
 *  @param api     Api Name
 *  @param method  RequestMethod Enum
 *  @param params  如果请求带参，要打开Block并返回Params
 *  @param success 请求成功的回调Block
 *  @param failed  请求失败的回调Block
 */
+ (void)requestData:(APIName *)api method:(RequestMethod)method params:(Params)params success:(Success)success failed:(Failed)failed;
@end
