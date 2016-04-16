//
//  ZToastManager.h
//  ZFramework
//
//  Created by liuchengbin on 15/5/9.
//  Copyright (c) 2015年 liuchengbin. All rights reserved.
//

#import "MBProgressHUD.h"

//定义显示HUD的每个动作，当此东西不需要显示是值设为小于0
typedef enum
{
    HUDShowType_None = 0,
    HUDShowType_RegExistPhone ,
    HUDShowType_RegOrGetPassGetCode,
    HUDShowType_RegOrGetPassAction,
    HUDShowType_GetPassExitPhone,
    HUDShowType_LoginAction,
    HUDShowType_LogoutAction,
    HUDShowType_ChangePassAction,
    HUDShowType_GetEvaOptionAction,
    HUDShowType_EvaAction,
    HUDShowType_PickLocationAction,
    HUDShowType_SaveAddress,
    HUDShowType_DefaultAddress,
    HUDShowType_DeleteAddress
    
}HUDShowType;


@interface ZToastManager : NSObject

+ (ZToastManager *)ShardInstance;

// toast
- (void)showtoast:(NSString *)toastStr;
- (void)showtoast:(NSString *)toastStr wait:(double)wait;

// progress
- (void)hideprogress;
- (void)showprogress;
- (void)showHUD:(HUDShowType)type;
@end
