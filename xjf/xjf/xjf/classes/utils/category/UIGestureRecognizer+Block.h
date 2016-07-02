//
//  UIGestureRecognizer+Block.h
//  RuntimeTest
//
//  Created by Hunter_wang on 16/6/29.
//  Copyright © 2016年 Hunter_wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTGestureBlock)(id gestureRecognizer);

@interface UIGestureRecognizer (Block)

/**
 *  使用类方法 初始化 添加手势
 *
 *  @param block 手势回调
 *
 *  @return block 内部 action
 *
 *
 *  使用 __unsafe_unretained __typeof(self) weakSelf = self;
 *  防止循环引用
 *
 */


+ (instancetype)ht_gestureRecognizerWithActionBlock:(HTGestureBlock)block;

@property (nonatomic, strong) NSString *test;

@end
