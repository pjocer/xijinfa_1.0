//
//  BaseNavigationController.h
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface BaseNavigationController : UINavigationController
- (void)startPopAnimation;
-(void)pushViewControllerByCustomAnimation:(UIViewController *)viewController;
@end
