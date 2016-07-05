//
//  UIView+Addtion.m
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UIView+Addtion.h"

#define GrayColorLine RGB(234, 234, 234)

@implementation UIView (Addtion)

- (void)addShadow {
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 0.05;
    self.layer.masksToBounds = NO;
}

- (UIView *)addBottomLine {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(
            0,
            self.frame.size.height - 1 / [UIScreen mainScreen].scale,
            SCREENWITH,
            1 / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = GrayColorLine;
    [self addSubview:lineView];
    return lineView;
}
- (UIView *)addBottomLine:(CGFloat)lineHeight {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height - lineHeight / [UIScreen mainScreen].scale,SCREENWITH,lineHeight / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = GrayColorLine;
    [self addSubview:lineView];
    return lineView;
}
-(void)setBackgroundColorByTopColor:(UIColor *)topColor BottomColor:(UIColor *)bottomColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id) topColor.CGColor, (id) bottomColor.CGColor];
    for (CALayer *sublayer in [self.layer sublayers]) {
        [sublayer removeFromSuperlayer];
    }
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
