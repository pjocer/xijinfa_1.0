//
//  CommonMarco.h
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

#define    kUMengKey @"55c0844267e58ef73e002c02"
#define    kWXAppID @"wxd7f98efd8f93dbff"
#define    kWXAppKey @"13f405e5b46fbb1b1f9a934287d191c5"
#define    kQQAppID @"1104807398"
#define    kQQAppKey @"7pgyqaGO29iju2ck"
#define    kWBAppID @"1073901728"
#define    kWBAppKey @"b94207cba10d4bc6f5449e3f09d438ec"
#define    kWBRUrl @"http://api.danpin.com/redirect_weibo.php"

///  APP KEY
#define APP_KEY_WEIXIN            @"wxd7f98efd8f93dbff"

#define APP_KEY_QQ                @"1104807398"

#define APP_KEY_WEIBO             @"1073901728"

#define APP_KEY_WEIBO_RedirectURL @"http://api.danpin.com/redirect_weibo.php"

///  分享图片
#define SHARE_IMG [UIImage imageNamed:@"logo.jpg"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5

///  Common size
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size


/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;


#endif
