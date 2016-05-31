//
//  XjfRequest.h
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString APIName;

@class XjfRequest;

typedef NS_OPTIONS(short, RequestMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE
};

typedef void(^SuccessBlock)( NSData * _Nullable responseData);
typedef void(^FailedBlock)(NSError * _Nullable error);


@interface XjfRequest : NSObject

@property (nonatomic, strong, nullable) NSDictionary *requestHeaders;

@property (nonatomic, assign, readonly) RequestMethod requestMethod;

@property (nonatomic, strong, nullable) NSMutableDictionary *requestParams;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, readonly) NSInteger responseStatusCode;

- (nullable instancetype)initWithAPIName:(nonnull APIName *)apiName RequestMethod:(RequestMethod)method;

- (void)startWithSuccessBlock:(nullable SuccessBlock)successBlock failedBlock:(nullable FailedBlock)failedBlock;

- (void)setValue:(nonnull NSString *)value forHTTPHeaderField:(nonnull NSString *)filed;

@end
