//
//  UIView+Addtion.h
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addtion)
- (void)addShadow;

- (UIView *)addBottomLine;

- (UIView *)addBottomLine:(CGFloat)lineHeight;
/**
 *  颜色渐变(上下)
 *
 *  @param frame       需要绘制View的Frame
 *  @param topColor    ViewTopColor
 *  @param bottomColor ViewBottomColor
 *  @param layer       View的Layer
 */
- (void)setBackgroundColorByTopColor:(UIColor *)topColor
                         BottomColor:(UIColor *)bottomColor;


/**
 *  切圆角
 *
 *  @param corner      UIRectCorner
 *  @param cornerRadii Size
 */
- (void)setViewCornerRadius:(UIRectCorner)corner CornerRadii:(CGSize)cornerRadii;

@end
