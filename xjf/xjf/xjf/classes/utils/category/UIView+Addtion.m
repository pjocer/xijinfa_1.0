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

- (UIView *)addBottomLine
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1 / [UIScreen mainScreen].scale, SCREENWITH, 1 / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = GrayColorLine;
    [self addSubview:lineView];
    return lineView;
}

- (void)setBackgroundColorByFrame:(CGRect)frame
                         TopColor:(UIColor *)topColor
                      BottomColor:(UIColor *)bottomColor
                            Layer:(CALayer *)layer

{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    for (CALayer *sublayer in [layer sublayers])
    {
        [sublayer removeFromSuperlayer];
    }
    [layer insertSublayer:gradientLayer atIndex:0];
    
}

@end
