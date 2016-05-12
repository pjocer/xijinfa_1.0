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
NSString * const Index = @"IndexViewController";
NSString * const My = @"MyViewController";
NSString * const Topic = @"TopicViewController";
NSString * const Vip = @"VipViewController";
NSString * const Subscribe = @"SubscribeViewController";

@interface BaseViewController ()<UserDelegate>
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *rightButton;
@end

@implementation BaseViewController
@synthesize headView=_headView;
@synthesize backButton=_backButton;
@synthesize rightButton=_rightButton;
@synthesize isIndex=_isIndex;
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor xjfStringToColor:@"#444444"]];
    [self.navigationController.navigationBar addShadow];
    //去除NacigationBar底部黑线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    if (!self.isIndex) {
        self.navigationController.navigationBarHidden = NO;
        if (self.headView) {
            self.headView.hidden = YES;
        }
    }else {
        self.navigationController.navigationBarHidden = YES;
        if (self.headView) {
            self.headView.hidden = NO;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
}
-(void)dealloc
{
    
    self.backButton=nil;
    self.rightButton =nil;
    self.titleLabel=nil;
    self.headView=nil;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)extendheadViewFor:(NSString *)name {
    [self initHeaderView];
    self.navigationItem.title = @"";
    self.isIndex = YES;
    if ([name isEqualToString:My]) {
        _titleLabel.text = @"我的";
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        downButton.tag =9;
        downButton.titleLabel.font =FONT(14);
        [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [downButton setTitle:@"通知" forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:downButton];
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        searchButton.tag =13;
        searchButton.hidden=NO;
        searchButton.titleLabel.font =FONT(14);
        [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [searchButton setTitle:@"设置" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:searchButton];
    }else if ([name isEqualToString:Index]) {
        _titleLabel.text = @"首页";
        UIButton *hisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hisButton.frame = CGRectMake(SCREENWITH -160, 20+(HEADHEIGHT-20-25)/2, 30, 25);
        hisButton.tag =10;
        hisButton.hidden = NO;
        hisButton.titleLabel.font =FONT(14);
        [hisButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [hisButton setTitle:@"历史" forState:UIControlStateNormal];
        [hisButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:hisButton];
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        downButton.tag =11;
        downButton.hidden=NO;
        downButton.titleLabel.font =FONT(14);
        [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [downButton setTitle:@"下载" forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:downButton];
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        searchButton.tag =12;
        searchButton.hidden=NO;
        searchButton.titleLabel.font =FONT(14);
        [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:searchButton];
    }else if ([name isEqualToString:Subscribe]) {
        _titleLabel.text = @"订阅";
    }else if ([name isEqualToString:Topic]) {
        _titleLabel.text = @"话题";
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        downButton.tag =14;
        downButton.hidden=NO;
        downButton.titleLabel.font =FONT(14);
        [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [downButton setTitle:@"发表" forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:downButton];
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        searchButton.tag =15;
        searchButton.hidden=NO;
        searchButton.titleLabel.font =FONT(14);
        [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView  addSubview:searchButton];
    }else if ([name isEqualToString:Vip]) {
        _titleLabel.text = @"会员";
    }
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
        case 9://通知
        {
            
        }
        case 10://历史
        {
            PlayerHistoryViewController *history =[[PlayerHistoryViewController alloc] init];
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        case 11://下载
        {
            PlayerDownLoadViewController *download =[[PlayerDownLoadViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        }
            break;
        case 12://搜索 #import "SearchViewController.h"
        {
            SearchViewController *download =[[SearchViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
            
        }
            break;
        case 13://设置
        {
            SettingViewController *download =[[SettingViewController alloc] init];
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

-(void)initHeaderView
{
    self.navigationController.navigationBarHidden = YES;
    _headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, HEADHEIGHT)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 15+(HEADHEIGHT-20-20)/2, 35, 35)];
    iconImage.image = [UIImage imageNamed:@"Logo"];
    [_headView addSubview:iconImage];
    
    _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+8, 21+(HEADHEIGHT-20-20)/2, self.view.frame.size.width/2, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = FONT(16);
    [_headView addSubview:_titleLabel];
    
    [self.view addSubview:_headView];
}

-(UIView *)footerView:(NSString*)msg
{
    if (msg==nil || msg.length==0) {
        msg=@"互联网领先在线教育";
    }
    UIView *footerview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    footerview.backgroundColor=[UIColor clearColor];
    UILabel *footLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 20)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textColor = UIColorFromRGB(0xcccccc);
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = FONT(14);
    footLabel.text =msg;
    [footerview addSubview:footLabel];
    return footerview;
}

-(BOOL)isLogin
{
    return NO;
}
-(void)userLoginOK:(id)userinfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)userDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
