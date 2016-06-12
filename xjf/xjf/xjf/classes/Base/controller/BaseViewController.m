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
#import "SearchViewController.h"
#import "NewTopicViewController.h"
#import "XJAccountManager.h"
#import "ZToastManager.h"
#import "MyPlayerHistoryViewController.h"

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
    self.nav_title = @"";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addShadow];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.view.backgroundColor = BackgroundColor;
}

-(void)extendheadViewFor:(NSString *)name {
    if ([name isEqualToString:My]) {
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 13;
        self.navigationItem.rightBarButtonItem = item2;
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
    [self initLeftItemWith:name];
}

- (void)initLeftItemWith:(NSString *)name {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 63, 24)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imageView.image = [UIImage imageNamed:@"nav_left"];
    [view addSubview:imageView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(29, 0, 34, 24)];
    if ([name isEqualToString:My]) {
        title.text = @"我的";
    }else if ([name isEqualToString:Index]) {
        title.text = @"首页";
    }else if ([name isEqualToString:Topic]) {
        title.text = @"话题";
    }else if ([name isEqualToString:Vip]){
        title.text = @"会员";
    }
    title.font = FONT(17);
    [view addSubview:title];
    UIBarButtonItem *item_left = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item_left;
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
        case 10://历史
        {
            MyPlayerHistoryViewController *history = [[MyPlayerHistoryViewController alloc] init];
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
            break;
        }
            break;
        case 14://发表
        {
            if (![[XJAccountManager defaultManager] accessToken]) {
                [[ZToastManager ShardInstance] showtoast:@"请先登录"];
                return;
            }
            NewTopicStyle style = NewTopicDefaultStyle;
            if (self.topicTag == 1) {
                style = NewTopicQAStyle;
            }else if (self.topicTag == 2) {
                style = NewTopicDiscussStyle;
            }
            NewTopicViewController *controller = [[NewTopicViewController alloc] initWithStyle:style];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 15://搜索
        {
            SearchViewController *download = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)setNav_title:(NSString *)nav_title {
    _nav_title = nav_title;
    self.navigationItem.title = nav_title;
}
@end
