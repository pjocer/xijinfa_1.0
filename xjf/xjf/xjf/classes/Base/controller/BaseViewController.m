//
//  BaseViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "IndexConfigure.h"
#import "myConfigure.h"

NSString *const Index = @"IndexViewController";
NSString *const My = @"MyViewController";
NSString *const Topic = @"TopicViewController";
NSString *const Vip = @"VipViewController";
NSString *const Subscribe = @"SubscribeViewController";

@interface BaseViewController () <UserDelegate>
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.nav_title) {
        self.navigationItem.title = self.nav_title;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"   ";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addShadow];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.view.backgroundColor = BackgroundColor;
}
-(void)extendheadViewFor:(NSString *)name {
    if ([name isEqualToString:My]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notification"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item.tag = 9;
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 13;
        self.navigationItem.rightBarButtonItems = @[item,item2];
    } else if ([name isEqualToString:Index]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item.tag = 10;
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 12;
        self.navigationItem.rightBarButtonItems = @[item,item2];
    } else if ([name isEqualToString:Topic]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pulish"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item.tag = 14;
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 15;
        self.navigationItem.rightBarButtonItems = @[item,item2];
    } else if ([name isEqualToString:Vip]) {
        
    }
}

- (void)headerClickEvent:(id)sender {
    UIButton *btn = (UIButton *) sender;
    switch (btn.tag) {
        case 0: {
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
        case 9://通知
        {

        }
        case 10://历史
        {
            PlayerHistoryViewController *history = [[PlayerHistoryViewController alloc] init];
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        case 11://下载
        {
//            PlayerDownLoadViewController *download =[[PlayerDownLoadViewController alloc] init];
//            [self.navigationController pushViewController:download animated:YES];
        }
            break;
        case 12://搜索 #import "SearchViewController.h"
        {
            SearchViewController *download = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];

        }
            break;
        case 13://设置
        {
            SettingViewController *download = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        }
        case 14://发表
        {


        }
            break;
        case 15://搜索
        {

        }
        default:
            break;
    }
}
-(void)setNav_title:(NSString *)nav_title {
    _nav_title = nav_title;
    self.navigationItem.title = nav_title;
}
@end
