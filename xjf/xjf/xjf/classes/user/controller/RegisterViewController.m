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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)headerClickEvent:(id)sender
{
    UIButton *btn =(UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (self.navigationController) {
                if (self.navigationController.viewControllers.count == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

@end
