//
//  StudyCenterViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "StudyCenterViewController.h"
#import "StudyCenterSelectedView.h"

@interface StudyCenterViewController ()
@property (nonatomic, strong)StudyCenterSelectedView *studyCenterSelectedView;
@end

@implementation StudyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self setStudyCenterSelectedView];
}


#pragma mark - Navigation

- (void)setNavigation {
    self.navigationItem.title = @"学习中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"search"]
                                              style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {

}

#pragma mark - setStudyCenterSelectedView

- (void)setStudyCenterSelectedView
{
//    self.studyCenterSelectedView = [[[NSBundle mainBundle] loadNibNamed:@"StudyCenterSelectedView" owner:self options:nil] lastObject];
//    self.studyCenterSelectedView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//    [self.view addSubview:self.studyCenterSelectedView];
}

@end
