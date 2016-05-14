//
//  BaseUINavigationController.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseUINavigationController.h"

@interface BaseUINavigationController ()

@end

@implementation BaseUINavigationController

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
