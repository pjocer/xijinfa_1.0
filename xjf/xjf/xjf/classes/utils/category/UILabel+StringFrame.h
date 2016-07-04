//
//  UILabel+StringFrame.h
//  danpin
//
//  Created by chuangjia on 1/9/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;

/**
 *  关键字高亮
 *
 *  @param string 主字符串
 *  @param light  主字符串中要改变的字符串
 *  @param font   设置的字体大小
 *  @param color  高亮的颜色
 *
 *  @return NSMutableAttributedString
 */
- (void)changeColorWithString:(NSString *)string
                        light:(NSString *)light
                         Font:(CGFloat)font
                        Color:(UIColor *)color;
@end
