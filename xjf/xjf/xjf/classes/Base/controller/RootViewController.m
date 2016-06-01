//
//  RootViewController.m
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RootViewController.h"
#import "IndexViewController.h"
#import "TopicViewController.h"
#import "VipViewController.h"
#import "MyViewController.h"
#import "PlayerViewController.h"
#import "LessonPlayerViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers {
    IndexViewController *vc1 = [[IndexViewController alloc] init];
    vc1.tabBarItem.badgeValue = @"8";
    [self setupChildViewController:vc1
                             title:@"首页"
                         imageName:@"tab_home"
                 selectedImageName:@"tab_home_selected"];

    TopicViewController *vc2 = [[TopicViewController alloc] init];
    [self setupChildViewController:vc2
                             title:@"话题"
                         imageName:@"tab_topic"
                 selectedImageName:@"tab_topic_selected"];

    VipViewController *vc3 = [[VipViewController alloc] init];
    [self setupChildViewController:vc3
                             title:@"会员"
                         imageName:@"tab_vip"
                 selectedImageName:@"tab_vip_selected"];

    MyViewController *vc5 = [[MyViewController alloc] init];
    [self setupChildViewController:vc5
                             title:@"我的"
                         imageName:@"tab_user"
                 selectedImageName:@"tab_user_selected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc
                           title:(NSString *)title
                       imageName:(NSString *)imageName
               selectedImageName:(NSString *)selectedImageName {

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 1.设置控制器的属性
//    childVc.title = title;
    // 3.添加tabbar内部的按钮
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:[UIImage imageNamed:selectedImageName]];
    item.titlePositionAdjustment = UIOffsetMake(0, -4.5f);
    nav.tabBarItem = item;
    [self addChildViewController:nav];
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    if ([nav.topViewController isKindOfClass:[PlayerViewController class]]
            || [nav.topViewController isKindOfClass:[LessonPlayerViewController class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
