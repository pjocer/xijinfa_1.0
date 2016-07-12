//
//  XJRequest.m
//  xjf
//
//  Created by PerryJ on 16/7/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJRequest.h"

@implementation XJRequest
+(void)requestData:(APIName *)api method:(RequestMethod)method params:(Params)params success:(Success)success failed:(Failed)failed {
    XJRequest *request = [[super alloc] initWithAPIName:api RequestMethod:method];
    if (params()) {
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
        if (failed) failed (request);
    }];
}
@end
