//
//  xjfConfigure.h
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//
/*
 
 //各种机型尺寸
 iPad Air {{0, 0}, {768, 1024}}
 //Iphone4: 4s :{320,480}       960*640
 //Iphone5: 5s :{320,568}       1136*640
 //Iphone6: 6s :{375,667}       1334*750
 //iphone6plus{414,736}         1920*1080
 Apple Watch 1.65inches(英寸)    320*640
 */

#define ACCESS_TOKEN_WEIXIN @"access_token_weixin"
#define OPEN_ID_WEIXIN @"open_id_weixin"

#define ACCESS_TOKEN_QQ @"access_token_qq"
#define OPEN_ID_QQ @"open_id_qq"

//包含AccessToken在内的隐私数据
#define ACCOUNT_INFO @"account_info"
#define ACCOUNT_ACCESS_TOKEN @"account_access_token"
//用户信息
#define USER_INFO @"user_info"
///是否允许3G/4G player
#define USER_SETTING_WIFI @"USER_SETTING_WIFI"

#define HEADHEIGHT 64
#define SCREENWITH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width/375
#define HEIGHT [UIScreen mainScreen].bounds.size.height/667
#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f
//

//Color
#define PrimaryColor [UIColor xjfStringToColor:@"#0061b0"];
#define NormalColor [UIColor xjfStringToColor:@"#444444"];
#define AssistColor [UIColor xjfStringToColor:@"#9a9a9a"];
#define SegementColor [UIColor xjfStringToColor:@"#c7c7cc"];
#define BackgroundColor [UIColor xjfStringToColor:@"#efefef"];
#define BlueColor [UIColor xjfStringToColor:@"0061b0"];
//
#define LSpacing 2
#define PHOTO_FRAME_WIDTH_16   floor([UIScreen mainScreen].bounds.size.width/16)
#define PHOTO_FRAME_WIDTH   10
#define PHOTO_TIME_PADDING  floor([UIScreen mainScreen].bounds.size.width/64)
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//字体
#define FONT_NAME_BOLD   ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) ? (@"PingFangSC-Regular") : (@"STHeitiSC-Light"))
#define FONT_NAME  ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) ? (@"PingFangSC-Light") : (@"STHeitiSC-Light"))
#define FONT14 [UIFont systemFontOfSize:14.0f]
#define FONT16 [UIFont systemFontOfSize:16.0f]
#define FONT12 [UIFont systemFontOfSize:12.0f]
#define FONT13 [UIFont systemFontOfSize:13.0f]
#define FONT15 [UIFont systemFontOfSize:15.0f]
#define FONT10 [UIFont systemFontOfSize:10.0f]
#define FONT20 [UIFont systemFontOfSize:20.0f]
#define FONT18 [UIFont systemFontOfSize:18.0f]
#define FONT(Size)  [UIFont fontWithName:FONT_NAME size:Size]
#define FONT_BOLD(Size) [UIFont fontWithName:FONT_NAME_BOLD size:Size]
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//
// player的单例

//
#ifdef __OPTIMIZE__
# define DLog(...) {}
#else
# define DLog(fmt, ...)  NSLog((@"\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\
----------------------------------------App日志----START--------------------------------------\n\
[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt "\n-------------------------------------------END---------------------------------------------------\n\n\n\n"\
), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

//////////////////////////
#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif


//如果是 DEBUG 模式用测试服务器地址
#if DEBUG

#define     HttpBaseURL        @"http://www.test.com/" // 测试服务器

#else

#define     HttpBaseURL        @"http://www.baidu.com/" // 正式服务器

#endif

/**
 *  the saving objects      存储对象
 *
 *  @param __VALUE__ V
 *  @param __KEY__   K
 *
 *  @return
 */
#define UserDefaultSetObjectForKey(__VALUE__, __KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

/**
 *  get the saved objects       获得存储的对象
 */
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

/**
 *  delete objects      删除对象
 */
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

//GCD
#define GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)


//----------------------ABOUT SYSTYM & VERSION 系统与版本 ----------------------------
//Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//judge the simulator or hardware device        判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** 获取系统版本 */
#define iOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

/** 是否为iOS6 */
#define iOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? YES : NO)

/** 是否为iOS7 */
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

/** 是否为iOS8 */
#define iOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

/** 是否为iOS9 */
#define iOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

/** 获取当前语言 */
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

