//
//  ZFPlayerView+Category.m
//  xjf
//
//  Created by PerryJ on 16/6/23.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "ZFPlayerView+Category.h"
#import <objc/runtime.h>
@implementation ZFPlayerView (Category)
- (void)setXjfloading_image:(UIImage *)xjfloading_image {
    self.layer.contents = (id) xjfloading_image.CGImage;
    objc_setAssociatedObject(self, @selector(xjfloading_image), xjfloading_image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)xjfloading_image {
    return objc_getAssociatedObject(self, @selector(xjfloading_image));
}
@end
