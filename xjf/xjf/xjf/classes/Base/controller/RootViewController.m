//
//  RootViewController.m
//  xjf
//
//  Created by yiban on 16/4/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RootViewController.h"
#import "TopicViewController.h"
#import "PlayerViewController.h"
#import "LessonPlayerViewController.h"
#import "HomePageMainViewController.h"
#import "UserInfoController.h"
#import "XJAccountManager.h"
#import "BaseNavigationController.h"
#import "StudyCenter.h"
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
    [self setupAllChildViewControllers];
}
- (void)setupAllChildViewControllers {
    HomePageMainViewController *vc1 = [[HomePageMainViewController alloc] init];
    vc1.tabBarItem.badgeValue = @"8";
    [self setupChildViewController:vc1
                             title:@"首页"
                         imageName:@"tab_home"
                 selectedImageName:@"tab_home_selected"];
    
    StudyCenter *vc2 = [[StudyCenter alloc] init];
    [self setupChildViewController:vc2
                             title:@"学习"
                         imageName:@"tab_study"
                 selectedImageName:@"tab_study_selected"];

    TopicViewController *vc3 = [[TopicViewController alloc] init];
    [self setupChildViewController:vc3
                             title:@"讨论"
                         imageName:@"tab_topic"
                 selectedImageName:@"tab_topic_selected"];

    UserInfoController *vc4 = [[UserInfoController alloc] initWithUserType:Myself
                                                                  userInfo:[[[XJAccountManager defaultManager] user_model] result]];
    [self setupChildViewController:vc4
                             title:@"我的"
                         imageName:@"tab_user"
                 selectedImageName:@"tab_user_selected"];
}
- (void)setupChildViewController:(UIViewController *)childVc
                           title:(NSString *)title
                       imageName:(NSString *)imageName
               selectedImageName:(NSString *)selectedImageName {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
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

// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate {
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    // MoviePlayerViewController 、ZFTableViewController 控制器支持自动转屏
    if ([nav.topViewController isKindOfClass:[PlayerViewController class]]
            || [nav.topViewController isKindOfClass:[LessonPlayerViewController class]]) {
        // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
        return !ZFPlayerShared.isLockScreen;
    }
    return NO;
}


@end
