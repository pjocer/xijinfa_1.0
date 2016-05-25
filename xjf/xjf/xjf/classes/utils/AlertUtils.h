//
//  AlertUtils.h
//  QCColumbus
//
//  Created by Chen on 15/6/2.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertUtils : NSObject

//默认的alertview
+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmBlock:(dispatch_block_t)comfirmBlock;

//可改变alertview cancel 和 conform title
+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
           confirmBlock:(dispatch_block_t)comfirmBlock;

//可实现cancel 和 conform block
+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
            cancelBlock:(dispatch_block_t)cancelBlock
           confirmBlock:(dispatch_block_t)confirmBlock;

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                okTitle:(NSString *)okTitle
             otherTitle:(NSString *)otherTitle
      cancelButtonTitle:(NSString *)cancelButtonTitle
                message:(NSString *)message
            cancelBlock:(dispatch_block_t)cancelBlock
                okBlock:(dispatch_block_t)okBlock
             otherBlock:(dispatch_block_t)otherBlock;
@end
