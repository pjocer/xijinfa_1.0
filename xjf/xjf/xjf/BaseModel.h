//
//  BaseModel.h
//  xjf
//
//  Created by PerryJ on 16/7/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseModel : JSONModel
@end

@interface ImageCode : BaseModel
@property (nonatomic, copy) NSString *secure_code;
@property (nonatomic, copy) NSString *secure_image;
@property (nonatomic, copy) NSString *secure_key;
@end