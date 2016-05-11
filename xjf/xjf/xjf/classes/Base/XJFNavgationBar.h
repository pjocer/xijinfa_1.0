//
//  XJFNavgationBar.h
//  xjf
//
//  Created by PerryJ on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XJFNavgationBarStyle) {
    XJFNavgationBarStyleDefault = 0,  //参考我的页面
    XJFNavgationBarStyleCustom,       //自定义
    XJFNavgationBarStyleSystem        //系统风格
};


@interface XJFNavgationBar : UIView

+ (instancetype)sharedBar;

- (instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

@interface XJFNavgationBar (Setting)

- (void)setBarStyle:(XJFNavgationBarStyle)barStyle;

@end
