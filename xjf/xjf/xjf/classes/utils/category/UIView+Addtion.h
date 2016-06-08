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
/**
 *  颜色渐变(上下)
 *
 *  @param frame       需要绘制View的Frame
 *  @param topColor    ViewTopColor
 *  @param bottomColor ViewBottomColor
 *  @param layer       View的Layer
 */
- (void)setBackgroundColorByFrame:(CGRect)frame
                         TopColor:(UIColor *)topColor
                      BottomColor:(UIColor *)bottomColor
                            Layer:(CALayer *)layer;
@end
