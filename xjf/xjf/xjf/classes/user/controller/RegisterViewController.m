//
//  RegisterViewController.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    
}
@property (weak) id<UserDelegate> delegate;
+ (instancetype)newController;
@end

@implementation RegisterViewController
+ (instancetype)newController
{
    return [super new];
}
+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate
{
    RegisterViewController *viewController = [RegisterViewController newController];
    
    if (viewController) {
        viewController.delegate = delegate;
    }
    
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
