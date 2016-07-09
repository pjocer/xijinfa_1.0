//
//  ImageCodeModel.h
//  xjf
//
//  Created by PerryJ on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@interface ResultModel : JSONModel
@property (nonatomic, copy) NSString *secure_code;
@property (nonatomic, copy) NSString *secure_image;
@property (nonatomic, copy) NSString *secure_key;
@end

@interface ImageCodeModel : JSONModel
@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) ResultModel *result;
@end
