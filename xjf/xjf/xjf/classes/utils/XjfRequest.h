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
    DELETE,
    UPLOAD
};

typedef void(^SuccessBlock)(NSData *_Nullable responseData);

typedef void(^FailedBlock)(NSError *_Nullable error);


@interface XjfRequest : NSObject
/**
 *  Current Request Headers
 */
@property (nonatomic, strong, nullable) NSDictionary *requestHeaders;
/**
 *  Current Request Method
 */
@property (nonatomic, assign, readonly) RequestMethod requestMethod;
/**
 *  Params of Request,Excepted GET Reqeust Method
 */
@property (nonatomic, strong, nullable) NSMutableDictionary *requestParams;
/**
 *  Timeout Interval In Current Reqeust,ReadWrite
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/**
 *  Response Status Code Within HTTP/
 */
@property (nonatomic, readonly) NSInteger responseStatusCode;
/**
 *  Upload Request Need
 */
@property (nonatomic, strong, nullable) NSData *fileData;

/**
 *  XjfRequest Initializing Method
 *
 *  @param apiName Ruquest Url
 *  @param method  Request Method
 *
 *  @return XjfReqeust Object
 */
- (nullable instancetype)initWithAPIName:(nonnull APIName *)apiName RequestMethod:(RequestMethod)method;

/**
 *  XjfRequest Initializing Method
 *
 *  @param apiName Reqeust API
 *  @param fileUrl    Upload Data Url Shouldn't Be File URL
 *
 *  @return XjfRequest Object
 */
- (nullable instancetype)initWithAPIName:(nonnull APIName *)apiName fileURL:(nullable NSURL *)url;

/**
 *  Start Request Data From Host
 *
 *  @param successBlock Return If Server Response Whatever Response ErrorCode Counld Not Be 0
 *  @param failedBlock  Return If Server Did Not Response
 */
- (void)startWithSuccessBlock:(nullable SuccessBlock)successBlock failedBlock:(nullable FailedBlock)failedBlock;

/**
 *  Set HTTPHeaderFile
 *
 *  @param value Header
 *  @param filed Key
 */
- (void)setValue:(nonnull NSString *)value forHTTPHeaderField:(nonnull NSString *)filed;

@end
