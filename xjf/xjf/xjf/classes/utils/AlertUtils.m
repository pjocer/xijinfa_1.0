//
//  AlertUtils.m
//  QCColumbus
//
//  Created by Chen on 15/6/2.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "AlertUtils.h"
@implementation AlertUtils

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmBlock:(dispatch_block_t)confirmBlock{
   [self alertWithTarget:target
                   Title:title
                 content:content
            confirmTitle:@"确定"
             cancelTitle:@"取消"
             cancelBlock:nil
            confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
           confirmBlock:(dispatch_block_t)confirmBlock{
   [self alertWithTarget:target
                   Title:title
                 content:content
            confirmTitle:confirmTitle
             cancelTitle:cancelTitle
             cancelBlock:nil
            confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
            cancelBlock:(dispatch_block_t)cancelBlock
           confirmBlock:(dispatch_block_t)confirmBlock{
    [self alertWithTarget:target
                    Title:title
                  content:content
             confirmTitle:confirmTitle
              cancelTitle:cancelTitle
              cancelBlock:cancelBlock
             confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  Title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
            cancelBlock:(dispatch_block_t)cancelBlock
           confirmBlock:(dispatch_block_t)confirmBlock{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:content
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        if(cancelTitle.length > 0){
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:cancelTitle
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action) {
                if(cancelBlock){
                   cancelBlock();
                }
            }];
            [alertController  addAction:cancelAction];
        }
        
        UIAlertAction *confirmAction = [UIAlertAction
                                        actionWithTitle:confirmTitle
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
            if(confirmBlock){
               confirmBlock();
            }
        }];
        [alertController  addAction:confirmAction];
        
        [target presentViewController:alertController animated:YES completion:nil];
}
@end
