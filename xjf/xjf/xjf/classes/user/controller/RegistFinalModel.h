//
//  RegistFinalModel.h
//  xjf
//
//  Created by PerryJ on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OptionalJSONModel.h"

@interface ResultUserModel : JSONModel
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *updated_at;
@end

@interface ResultCredentialModel : JSONModel
@property (nonatomic, copy) NSString *bearer;
@property (nonatomic, copy) NSString *expired_at;
@end

@interface RegistFinalResultModel : JSONModel
@property (nonatomic, strong) ResultCredentialModel *credential;
@property (nonatomic, strong) ResultUserModel *user;
@end

@interface RegistFinalModel : JSONModel
@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, strong) RegistFinalResultModel *result;
@end
