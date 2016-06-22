//
//  PhotoHandler.h
//  xjf
//
//  Created by PerryJ on 16/6/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Handle Photos Instruction
 */
@interface PhotoHandler : NSObject
- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)type imagePickerDelegate:(id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate;
- (void)show;
-(instancetype)init NS_UNAVAILABLE;
@end
