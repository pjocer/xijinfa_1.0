//
//  LoginViewController.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LoginViewController.h"
#import "ZPlatformShare.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
}
@property(nonatomic,strong)void(^actionBlock)(id,id);
@property(nonatomic,strong) UITextField     *txtNickname;
@property(nonatomic,strong) UITextField     *txtPass;
@property(nonatomic,strong) UIButton     *loginBtn;
@property(nonatomic,strong) UIButton     *settingBtn;
@property(nonatomic,strong) UIButton     *registerBtn;
@property(nonatomic,strong) UIImageView  *iconView;
@property(nonatomic,strong) UILabel  *logLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitle =@"会员登陆";
    [self initUI];
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    self.view.userInteractionEnabled =YES;
    [self.view addGestureRecognizer:singleRecognizer];
    singleRecognizer=nil;
    
}
-(void)setSelectedCallBack:(void(^)(id,id))callback
{
    self.actionBlock=callback;
}
-(void)clickNavEvent:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            if ([_delegate respondsToSelector:@selector(userDidCancel)]) {
                [_delegate userDidCancel];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    DLog(@"%s", __PRETTY_FUNCTION__);
}
-(void)dealloc
{
    [self.txtNickname resignFirstResponder];
    [self.txtPass resignFirstResponder];
    self.txtNickname=nil;
    self.txtPass=nil;
    self.loginBtn=nil;
    self.settingBtn=nil;
    self.registerBtn=nil;
    self.iconView=nil;
    self.logLabel=nil;
    
    DLog(@"%s", __PRETTY_FUNCTION__);
}
-(UIImageView*)iconView
{
    if (!_iconView) {
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom1)];
        self.iconView =[[UIImageView alloc] initWithFrame:CGRectZero];
        self.iconView.frame = CGRectMake((SCREENWITH-80)/2,35, 80, 80);
        self.iconView.layer.cornerRadius=40;
        self.iconView.layer.masksToBounds = YES;
        self.iconView.image =[UIImage imageNamed:@"user_face.png"];
        self.iconView.userInteractionEnabled =YES;
        [self.iconView addGestureRecognizer:singleRecognizer];
        [self.view addSubview:self.iconView];
        singleRecognizer=nil;
    }
    
    return _iconView;
}
-(UILabel*)logLabel
{
    if (!_logLabel) {
        self.logLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        self.logLabel.backgroundColor =[UIColor clearColor];
        self.logLabel.font = FONT(12);
        self.logLabel.textColor =UIColorFromRGB(0xcccccc);
        self.logLabel.textAlignment = NSTextAlignmentCenter;
        self.logLabel.text =@" - 以一顶百";
        [self.view addSubview:self.logLabel];
    }
    return _logLabel;
}
-(UIButton*)loginBtn
{
    if (!_loginBtn) {
        self.loginBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.loginBtn.backgroundColor =UIColorFromRGB(0xd00202);
        self.loginBtn.layer.cornerRadius = 6;
        self.loginBtn.tag=0;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginBtn];
    }
    return _loginBtn;
}
-(UIButton*)registerBtn
{
    if (!_registerBtn) {
        self.registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.registerBtn.backgroundColor =[UIColor clearColor];
        self.registerBtn.tag= 1;
        self.registerBtn.titleLabel.font =FONT(13);
        [self.registerBtn setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"注册会员>" forState:UIControlStateNormal];
        [self.registerBtn addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.registerBtn];
    }
    return _registerBtn;
}
-(UIButton*)settingBtn
{
    if (!_settingBtn) {
        self.settingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.settingBtn.backgroundColor =[UIColor clearColor];
        self.settingBtn.tag =2;
        self.settingBtn.titleLabel.font =FONT(13);
        [self.settingBtn setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [self.settingBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        self.settingBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.settingBtn addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.settingBtn];
    }
    return _settingBtn;
}
-(UITextField *)txtNickname
{
    if (!_txtNickname) {
        self.txtNickname = [[UITextField alloc] initWithFrame:CGRectZero];
        self.txtNickname.placeholder = @" 邮箱地址/手机号";
        [self.txtNickname setBorderStyle:UITextBorderStyleRoundedRect];
        self.txtNickname.font = FONT(13);
        self.txtNickname.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
        self.txtNickname.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtNickname.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtNickname.returnKeyType = UIReturnKeyNext;
        self.txtNickname.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtNickname.delegate=self;
        [self.view addSubview:self.txtNickname];
    }
    return _txtNickname;
}
-(UITextField *)txtPass
{
    if (!_txtPass) {
        self.txtPass = [[UITextField alloc] initWithFrame:CGRectZero];
        self.txtPass.placeholder = @" 密码";
        [self.txtPass setBorderStyle:UITextBorderStyleRoundedRect];
        self.txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtPass.font = FONT(13);
        self.txtPass.secureTextEntry = YES;
        self.txtPass.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtPass.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtPass.returnKeyType = UIReturnKeyGo;
        self.txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtPass.delegate=self;
        [self.view addSubview:self.txtPass];
    }
    return _txtPass;
}

//按下Done按钮的调用方法，我们让键盘消失
-(void)handleSingleTapFrom
{
    [self.txtNickname resignFirstResponder];
    [self.txtPass resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.txtNickname) {
        [self.txtPass becomeFirstResponder];
    }else  if (textField==self.txtPass){
        [self btnLoginAction];
        [textField resignFirstResponder];
    }else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)initUI
{
    self.txtNickname.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, 100, SCREENWITH-PHOTO_FRAME_WIDTH*4, PHOTO_FRAME_WIDTH*4);
    self.txtPass.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, 150, SCREENWITH-PHOTO_FRAME_WIDTH*4, PHOTO_FRAME_WIDTH*4);
    self.loginBtn.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, 200, SCREENWITH-PHOTO_FRAME_WIDTH*4, PHOTO_FRAME_WIDTH*4);
    self.settingBtn.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, 250, PHOTO_FRAME_WIDTH*10, PHOTO_FRAME_WIDTH*4);
    self.registerBtn.frame =CGRectMake(SCREENWITH - PHOTO_FRAME_WIDTH*13, 250, PHOTO_FRAME_WIDTH*12, PHOTO_FRAME_WIDTH*4);
    
    UIImage *infoim =[UIImage imageNamed:@"dsfdl_title.png"];
    UIImageView *infoImage =[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-infoim.size.width)/2, 350,infoim.size.width , 20)];
    infoImage.image =infoim;
    [self.view addSubview:infoImage];
    
    CGFloat pading =(SCREENWITH - PHOTO_FRAME_WIDTH*3 - 50*3)/3;
    
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    UIButton *qq =[UIButton buttonWithType:UIButtonTypeCustom];
    qq.tag =4;
    qq.frame =CGRectMake(PHOTO_FRAME_WIDTH*5, 400,50 , 50);
    [qq setBackgroundImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qq];
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    UIButton *wx =[UIButton buttonWithType:UIButtonTypeCustom];
    wx.tag =5;
    wx.frame =CGRectMake(qq.frame.origin.x+qq.frame.size.width+pading, 400,50 , 50);
    [wx setBackgroundImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wx];
    
    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
    UIButton *sina =[UIButton buttonWithType:UIButtonTypeCustom];
    sina.tag =6;
    sina.frame =CGRectMake(wx.frame.origin.x+wx.frame.size.width+pading, 400,50 , 50);
    [sina setBackgroundImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
    [sina addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sina];
//    if (!hadInstalledQQ) {
//        qq.hidden=YES;
//    }
//    if (!hadInstalledWeixin) {
//        wx.hidden =YES;
//    }
//    if (!hadInstalledWeibo) {
//        sina.hidden=YES;
//    }
    
}
-(void)loginbtnClick:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            [self btnLoginAction];
        }
            break;
        case 1:
        {
            RegisterViewController *reg =[RegisterViewController newWithDelegate:_delegate];
            [self.navigationController pushViewController:reg animated:YES];
        }
            break;
        case 2:
        {
            
            
        }
            break;
        case 3:
        {
            
            
        }
            break;
        case 4:
        {
            __weak typeof (self) wSelf = self;
            [ZPlatformShare qqLoginWithSuccess:^(NSDictionary *message) {
                [wSelf thirdLogin:message type:@"3"];
            } failure:^(NSDictionary *message, NSError *error) {
                
            }];
            
        }
            break;
        case 5:
        {
            __weak typeof (self) wSelf = self;
            [ZPlatformShare wxLoginWithSuccess:^(NSDictionary *message) {
                [wSelf thirdLogin:message type:@"2"];
            } failure:^(NSDictionary *message, NSError *error) {
                
            }];
            
        }
            break;
        case 6:
        {
            __weak typeof (self) wSelf = self;
            [ZPlatformShare wbLoginWithSuccess:^(NSDictionary *message) {
                
                [wSelf thirdLogin:message type:@"4"];
            } failure:^(NSDictionary *message, NSError *error) {
                
            }];
            
        }
            break;
            
            
        default:
            break;
    }
}
-(void)thirdLogin:(NSDictionary *)message type:(NSString*)type
{
    //third_type：第三方网站编码，0-本站，1-淘宝，2-微信，3-qq，4-微博
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    [dict setValue:@"third_party" forKey:@"action"];
    [dict setValue:type forKey:@"third_type"];
    int typev =[type intValue];
    if (typev==1) {
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"nick_name"]] replaceNullString] forKey:@"nick_name"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"user_face"]] replaceNullString] forKey:@"user_face"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"third_id"]] replaceNullString] forKey:@"third_id"];
    }else if (typev==2) {
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"nickname"]] replaceNullString] forKey:@"nick_name"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"headimgurl"]] replaceNullString] forKey:@"user_face"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"openid"]] replaceNullString] forKey:@"third_id"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"accessToken"]] replaceNullString] forKey:@"accessToken"];
    }else if (typev==3) {
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"nickname"]] replaceNullString] forKey:@"nick_name"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"figureurl_qq_2"]]replaceNullString] forKey:@"user_face"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"openId"]] replaceNullString] forKey:@"third_id"];
        
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"accessToken"]] replaceNullString] forKey:@"accessToken"];
    }else if (typev==4)
    {
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"nick_name"]] replaceNullString] forKey:@"nick_name"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"user_face"]]replaceNullString] forKey:@"user_face"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"openId"]] replaceNullString] forKey:@"third_id"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"accessToken"]] replaceNullString] forKey:@"accessToken"];
        
        
    }
  
}
-(void)handleSingleTapFrom1
{
    
}
- (void)btnLoginAction
{
    if(self.txtNickname.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入邮箱地址"];
        return;
    }
    if(self.txtPass.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入密码"];
        return;
    }
    [[ZToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    
    [dict setValue:@"login" forKey:@"action"];
    [dict setValue:@"" forKey:@"nickname"];
    [dict setValue:self.txtNickname.text forKey:@"email"];
    [dict setValue:self.txtPass.text forKey:@"password"];
   
    
}
//-(void)parserResultObject:(id)resultObject
//{
//    if (resultObject==nil) {
//        return;
//    }
//    if (resultObject && [resultObject isKindOfClass:[NSDictionary class]]) {
//        {
//            [[ZToastManager ShardInstance] showtoast:[resultObject objectForKey:@"msg"]];
//            int code =[[resultObject objectForKey:@"code"] intValue];
//            if (code==1)
//            {
//                [[ZShare sharedInstance] initUserInfo:resultObject];
//                if (_delegate&&[_delegate respondsToSelector:@selector(userLoginOK:)]) {
//                    [_delegate userLoginOK:[ZShare sharedInstance].userInfo];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLoveList" object:nil];
//                
//            }else if (code==2)
//            {
//                UserThirdLogin *viewController = [UserThirdLogin newWithDelegate:_delegate userinfo:resultObject];
//                [self.navigationController pushViewController:viewController animated:YES];
//            }
//        }
//    }
//}

@end
