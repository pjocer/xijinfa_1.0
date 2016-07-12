//
//  XJRequest.m
//  xjf
//
//  Created by PerryJ on 16/7/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJRequest.h"
#import "ZToastManager.h"

@implementation XJRequest
+(void)requestData:(APIName *)api method:(RequestMethod)method params:(Params)params success:(Success)success failed:(Failed)failed {
    NSParameterAssert(api);
    NSParameterAssert(method);
    XJRequest *request = [[super alloc] initWithAPIName:api RequestMethod:method];
    if (params() && params && method!=GET) {
        request.requestParams = [NSMutableDictionary dictionaryWithDictionary:params()];
    }
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        request.errCode = [[dic objectForKey:@"errCode"] integerValue];
        request.errMsg = [dic objectForKey:@"errMsg"];
        request.result = [dic objectForKey:@"result"];
        if (success) success(request);
    } failedBlock:^(NSError * _Nullable error) {
        request.requestError = error;
        if (error) {NSLog(@"%@",error.description);}
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        if (failed) failed (request);
    }];
}
@end
