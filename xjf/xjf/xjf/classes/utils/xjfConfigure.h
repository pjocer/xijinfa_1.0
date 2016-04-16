//
//  xjfConfigure.h
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#define HEADHEIGHT 64
#define SCREENWITH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//
#define LSpacing 2
#define PHOTO_FRAME_WIDTH_16   floor([UIScreen mainScreen].bounds.size.width/16)
#define PHOTO_FRAME_WIDTH   10
#define PHOTO_TIME_PADDING  floor([UIScreen mainScreen].bounds.size.width/64)
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define FONT_NAME_BOLD   ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) ? (@"PingFangSC-Regular") : (@"STHeitiSC-Light"))
#define FONT_NAME  ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) ? (@"PingFangSC-Light") : (@"STHeitiSC-Light"))

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
