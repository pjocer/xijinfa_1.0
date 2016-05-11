//
//  BaseViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"
#import "UserNavigationController.h"
#import "XJFNavgationBar.h"
@interface BaseViewController ()<UserDelegate>

@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *rightButton;
@end

@implementation BaseViewController
@synthesize headView=_headView;
@synthesize backButton=_backButton;
@synthesize rightButton=_rightButton;
@synthesize isIndex=_isIndex;
@synthesize navTitle=_navTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor xjfStringToColor:@"#efefef"];
     self.navigationController.navigationBarHidden = YES;
    [self headerView];
}
-(void)dealloc
{
    self.backButton=nil;
    self.rightButton =nil;
    self.titleLabel=nil;
    self.navTitle =nil;
    self.headView=nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
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

-(void)headerView
{
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
    //
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 20+(HEADHEIGHT-20-25)/2, 30, 25);
    _backButton.tag =0;
    _backButton.hidden = NO;
    [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_backButton];
    //
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    _rightButton.tag =1;
    _rightButton.hidden=YES;
    _rightButton.titleLabel.font =FONT(14);
    [_rightButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_rightButton];
    [_headView addShadow];
    [self.view addSubview:_headView];
   
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
-(void)setIsIndex:(BOOL)isIndex
{
    _isIndex=isIndex;
    _backButton.hidden =YES;
    _rightButton.hidden =YES;
}
-(void)setNavTitle:(NSString *)navTitle
{
    _navTitle=navTitle;
    _titleLabel.text = navTitle;
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
    UserNavigationController *viewcontroller =[UserNavigationController newWithCameraDelegate:self];
    [self presentViewController:viewcontroller animated:NO completion:nil];
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
