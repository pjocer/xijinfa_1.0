//
//  RequestAPI.h
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

//注册页面获取短信验证码
static APIName *regist_message_code = @"/api/auth/generate-register-security-code";

//获取图片验证码
static APIName *get_image_code = @"/api/auth/captcha";

//重置密码
static APIName *reset_password = @"/api/auth/reset-password";