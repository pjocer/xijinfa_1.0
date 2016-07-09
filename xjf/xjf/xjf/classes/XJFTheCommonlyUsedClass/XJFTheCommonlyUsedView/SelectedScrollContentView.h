//
//  SelectedScrollContentView.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedScrollContentView : XJFBaseView

/**
 *  init
 *
 *  @param frame                frame
 *  @param targetViewController targetViewController
 *  @param block      blockReturnChildViewControllers
 *
 *  @return SelectedScrollContentView
 */
- (nullable instancetype)initWithFrame:(CGRect)frame
         targetViewController:(UIViewController *)targetViewController
  addChildViewControllerBlock:(dispatch_block_t)block NS_DESIGNATED_INITIALIZER;


/**
 *  changCurrunViewLocation
 *
 *  @param index index(角标)
 */
- (void)changCurrunViewLocation:(NSInteger)index;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END