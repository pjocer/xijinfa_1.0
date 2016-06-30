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
#import "RegistViewController.h"
#import "NewComment_Topic.h"
#import "UIImageView+WebCache.h"

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
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserInfoDidChangedNotification object:nil] subscribeNext:^(id x) {
        [self setTopicRightItem];
    }];
    self.nav_title = @"";
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addShadow];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.view.backgroundColor = BackgroundColor;
}

- (void)extendheadViewFor:(NSString *)name {
    UILabel *leftTitle = [[UILabel alloc] init];
    [leftTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftTitle];
    leftTitle.frame = CGRectMake(0, 0, 50, 20);
    if ([name isEqualToString:My]) {
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 13;
        self.navigationItem.rightBarButtonItem = item2;
        leftTitle.text = @"我的";
    } else if ([name isEqualToString:Index]) {

        //commentsButton
        UIButton *commentsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [commentsButton setTitle:@"🔎 输入你想找的内容" forState:UIControlStateNormal];
        commentsButton.backgroundColor = BackgroundColor;
        commentsButton.titleLabel.font = FONT13;
        [commentsButton setTintColor:[UIColor xjfStringToColor:@"#9a9a9a"]];
        commentsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        commentsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        ViewRadius(commentsButton, 5.0);
        commentsButton.frame = CGRectMake(0, 0, 224, 30);
        commentsButton.tag = 12;
        [commentsButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = commentsButton;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indexLogo"]]];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item.tag = 10;
        self.navigationItem.rightBarButtonItem = item;
    } else if ([name isEqualToString:Topic]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pulish"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item.tag = 14;
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(headerClickEvent:)];
        item2.tag = 15;
        self.navigationItem.rightBarButtonItems = @[item, item2];
        [self setTopicRightItem];
    } else if ([name isEqualToString:Vip]) {
        leftTitle.text = @"会员";
    }
}
- (void)setTopicRightItem {
    UIImage *image = nil;
    if ([[XJAccountManager defaultManager] accessToken]) {
        image = [UIImage imageWithData:UserDefaultObjectForKey(@"user_icon")];
    }else {
        image = [UIImage imageNamed:@"user_unload"];
    }
    [self setUpTopicLeftItemWithImage:image];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserInfoDidChangedNotification object:nil] subscribeNext:^(id x) {
        [self setUpTopicLeftItemWithImage:[UIImage imageWithData:UserDefaultObjectForKey(@"user_icon")]];
    }];
}
- (void)setUpTopicLeftItemWithImage:(UIImage *)image {
    UIButton *user_icon = [UIButton buttonWithType:UIButtonTypeSystem];
    [user_icon setBackgroundImage:image forState:UIControlStateNormal];
    user_icon.tag = 16;
    user_icon.frame = CGRectMake(0, 0, 30, 30);
    user_icon.layer.cornerRadius = 15;
    user_icon.layer.masksToBounds = YES;
    [user_icon addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:user_icon];
    UINavigationController *topicNac = [self.navigationController.tabBarController.childViewControllers objectAtIndex:1];
    [topicNac.viewControllers objectAtIndex:0].navigationItem.leftBarButtonItem = left;
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
            NewComment_Topic *controller = [[NewComment_Topic alloc] initWithType:NewTopic];
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
        case 16:
        {
            if ([[XJAccountManager defaultManager] accessToken]) {
                NSLog(@"用户个人中心页");
            }else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [getCurrentDisplayController().navigationController pushViewController:login animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setNav_title:(NSString *)nav_title {
    _nav_title = nav_title;
    self.navigationItem.title = nav_title;
}

- (void)LoginPrompt {
    [AlertUtils alertWithTarget:self title:@"登录您将获得更多功能"
                        okTitle:@"登录"
                     otherTitle:@"注册"
              cancelButtonTitle:@"取消"
                        message:@"参与话题讨论\n\n播放记录云同步\n\n更多金融专业课程"
                    cancelBlock:^{
                        NSLog(@"取消");
                    } okBlock:^{
                LoginViewController *loginPage = [LoginViewController new];
                [self.navigationController pushViewController:loginPage animated:YES];
            }        otherBlock:^{
                RegistViewController *registPage = [RegistViewController new];
                registPage.title_item = @"注册";
                [self.navigationController pushViewController:registPage animated:YES];
            }];
}

@end
