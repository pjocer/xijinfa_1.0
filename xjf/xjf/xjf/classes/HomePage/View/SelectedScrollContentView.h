//
//  SelectedScrollContentView.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseView.h"

@interface SelectedScrollContentView : XJFBaseView

/**
 *  init
 *
 *  @param frame                frame
 *  @param targetViewController targetViewController
 *  @param block      block初始化ChildViewControllers
 *
 *  @return SelectedScrollContentView
 */
- (instancetype)initWithFrame:(CGRect)frame
         targetViewController:(UIViewController *)targetViewController
  addChildViewControllerBlock:(void(^)())block;

@end
