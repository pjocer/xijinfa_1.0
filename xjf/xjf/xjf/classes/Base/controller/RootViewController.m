//
//  RootViewController.m
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RootViewController.h"
#import "ZFTabBar.h"
#import "UINavigationController+YRBackGesture.h"
#import "IndexViewController.h"
#import "TopicViewController.h"
#import "VipViewController.h"
#import "SubscribeViewController.h"
#import "MyViewController.h"
@interface RootViewController () <ZFTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ZFTabBar *customTabBar;
@end


@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if (self.selectedIndex == to && to == 0 ) {//双击刷新制定页面的列表
//        UINavigationController *nav = self.viewControllers[0];
//        IndexViewController *firstVC = nav.viewControllers[0];
//        [firstVC refrshUI];
    }
    self.selectedIndex = to;
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    IndexViewController *vc1 = [[IndexViewController alloc] init];
    vc1.tabBarItem.badgeValue = @"8";
    [self setupChildViewController:vc1 title:@"首页" imageName:@"tab_home" selectedImageName:@"tab_home_selected"];
    
    
    TopicViewController *vc2 = [[TopicViewController alloc] init];
    [self setupChildViewController:vc2 title:@"话题" imageName:@"tab_topic" selectedImageName:@"tab_topic_selected"];

    VipViewController *vc3 = [[VipViewController alloc] init];
    [self setupChildViewController:vc3 title:@"会员" imageName:@"tab_vip" selectedImageName:@"tab_vip_selected"];
    
//    SubscribeViewController *vc4 = [[SubscribeViewController alloc] init];
//    [self setupChildViewController:vc4 title:@"订阅" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];

    MyViewController *vc5 = [[MyViewController alloc] init];
    [self setupChildViewController:vc5 title:@"我的" imageName:@"tab_user" selectedImageName:@"tab_user_selected"];

}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
