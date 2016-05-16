//
//  LoginViewController.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LoginViewController.h"
#import "ZPlatformShare.h"
#import "RegistViewController.h"
#import "PasswordSettingViewController.h"
#import "RegistFinalModel.h"
#import "ImageCodeModel.h"
@interface LoginViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UserDelegate>
{
    
}
@property(nonatomic,strong)void(^actionBlock)(id,id);
@property(nonatomic,strong) UITextField     *txtNickname;
@property(nonatomic,strong) UITextField     *txtPass;
@property(nonatomic,strong) UITextField     *txtCode;
@property(nonatomic,strong) UIButton     *loginBtn;
@property(nonatomic,strong) UIButton     *settingBtn;
@property(nonatomic,strong) UIImageView *codeImageView;
@property(nonatomic,copy)   NSString *secure_key;
@property(nonatomic,copy)   NSString *secure_code;
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"登录";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hadLogin"]) {
        self.txtNickname.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    [self requestData:get_image_code method:GET params:nil];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initUI];
    
}
-(void)setSelectedCallBack:(void(^)(id,id))callback
{
    self.actionBlock=callback;
}
- (void)setNavigationBar {
    UIColor *normalColor = NormalColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:normalColor,NSFontAttributeName:[UIFont systemFontOfSize:16]};
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registAction:)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor,NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    self.view.userInteractionEnabled =YES;
    [self.view addGestureRecognizer:singleRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWITH-90, 10, 60, 30)];
        _codeImageView.layer.cornerRadius = 5;
        _codeImageView.backgroundColor = [UIColor clearColor];
        _codeImageView.layer.masksToBounds = YES;
        _codeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCodeImage:)];
        [_codeImageView addGestureRecognizer:tap];
    }
    return _codeImageView;
}

-(UIButton*)loginBtn
{
    if (!_loginBtn) {
        self.loginBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.loginBtn.backgroundColor =PrimaryColor;
        self.loginBtn.layer.cornerRadius = 6;
        self.loginBtn.tag=0;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginBtn];
    }
    return _loginBtn;
}

-(UIButton*)settingBtn
{
    if (!_settingBtn) {
        self.settingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.settingBtn.backgroundColor =[UIColor clearColor];
        self.settingBtn.tag =2;
        self.settingBtn.titleLabel.font =FONT(13);
        UIColor *color = AssistColor;
        [self.settingBtn setTitleColor:color forState:UIControlStateNormal];
        [self.settingBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        self.settingBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.settingBtn addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.txtPass addSubview:self.settingBtn];
    }
    return _settingBtn;
}
-(UITextField *)txtNickname
{
    if (!_txtNickname) {
        self.txtNickname = [[UITextField alloc] initWithFrame:CGRectZero];
        self.txtNickname.placeholder = @"邮箱地址/手机号";
        [self.txtNickname setBorderStyle:UITextBorderStyleNone];
        self.txtNickname.font = FONT(13);
        self.txtNickname.tag = 100;
        self.txtNickname.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
        self.txtNickname.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtNickname.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtNickname.returnKeyType = UIReturnKeyNext;
        self.txtNickname.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtNickname.delegate=self;
    }
    return _txtNickname;
}
-(UITextField *)txtPass
{
    if (!_txtPass) {
        self.txtPass = [[UITextField alloc] initWithFrame:CGRectZero];
        self.txtPass.placeholder = @"密码";
        [self.txtPass setBorderStyle:UITextBorderStyleNone];
        self.txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtPass.font = FONT(13);
        self.txtPass.tag = 101;
        self.txtPass.secureTextEntry = YES;
        self.txtPass.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtPass.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtPass.returnKeyType = UIReturnKeyNext;
        self.txtPass.delegate=self;
    }
    return _txtPass;
}

- (UITextField *)txtCode {
    if (!_txtCode) {
        self.txtCode = [[UITextField alloc]initWithFrame:CGRectZero];
        self.txtCode.placeholder = @"请输入图片验证码";
        [self.txtCode setBorderStyle:UITextBorderStyleNone];
        self.txtCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtCode.font = FONT13;
        self.txtCode.tag = 102;
        self.txtCode.secureTextEntry = YES;
        self.txtCode.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtCode.returnKeyType = UIReturnKeyGo;
        self.txtCode.delegate = self;
    }
    return _txtCode;
}

//按下Done按钮的调用方法，我们让键盘消失
-(void)handleSingleTapFrom
{
    [self.view endEditing:YES];
}


-(void)initUI
{
    self.txtNickname.frame =CGRectMake(20, 25.0, SCREENWITH, PHOTO_FRAME_WIDTH*5.0);
    [self addWhiteColorFor:self.txtNickname];
    self.txtPass.frame =CGRectMake(20, 76.0, SCREENWITH, PHOTO_FRAME_WIDTH*5.0);
    [self addWhiteColorFor:self.txtPass];
    self.txtCode.frame = CGRectMake(20, 127.0, SCREENWITH, PHOTO_FRAME_WIDTH*5.0);
    [self addWhiteColorFor:self.txtCode];
    self.loginBtn.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, CGRectGetMaxY(self.txtCode.frame)+25, SCREENWITH-PHOTO_FRAME_WIDTH*4, PHOTO_FRAME_WIDTH*5);
    self.settingBtn.frame = CGRectMake(SCREENWITH-90, 10, 60, 30);
    [self.txtCode addSubview:self.codeImageView];
    
    
    
    CGFloat qq_x = SCREENWITH/2-62.5;
    CGFloat y = CGRectGetMaxY(self.txtCode.frame)+100;
    CGFloat wechat_x = SCREENWITH/2+12.5;
    
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    UIButton *qq =[UIButton buttonWithType:UIButtonTypeCustom];
    qq.tag =4;
    qq.frame =CGRectMake(qq_x, y,50,50);
    [qq setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qq];
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    UIButton *wx =[UIButton buttonWithType:UIButtonTypeCustom];
    wx.tag =5;
    wx.frame =CGRectMake(wechat_x,y,50,50);
    [wx setBackgroundImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(loginbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wx];
    if (!hadInstalledQQ) {
        qq.hidden=YES;
    }
    if (!hadInstalledWeixin) {
        wx.hidden =YES;
    }
    
}

- (void)registAction:(UIBarButtonItem *)item {
    RegistViewController *controller = [RegistViewController newWithDelegate:self];
    controller.title_item = @"注册";
    [self.navigationController pushViewController:controller animated:YES];
}

//点击更换图片验证码
- (void)changeCodeImage:(UITapGestureRecognizer *)gesture {
    [self requestData:get_image_code method:GET params:nil];
}
- (void)addWhiteColorFor:(UITextField *)view {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 25.0+51*(view.tag-100), SCREENWITH, PHOTO_FRAME_WIDTH*5.0)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.view addSubview:view];
}
-(void)loginbtnClick:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    switch (btn.tag) {
        case 0://登录
        {
            [self btnLoginAction];
        }
            break;
        case 2://忘记密码
        {
            RegistViewController *controller = [RegistViewController newWithDelegate:self];
            controller.title_item = @"找回密码";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4://QQ登录
        {
            __weak typeof (self) wSelf = self;
            [ZPlatformShare qqLoginWithSuccess:^(NSDictionary *message) {
                [wSelf thirdLogin:message type:@"1"];
            } failure:^(NSDictionary *message, NSError *error) {
            }];
            
        }
            break;
        case 5://微信登录
        {
            __weak typeof (self) wSelf = self;
            [ZPlatformShare wxLoginWithSuccess:^(NSDictionary *message) {
                [wSelf thirdLogin:message type:@"2"];
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
    NSMutableDictionary *dict = nil;
    XjfRequest *request = nil;
    int typev =[type intValue];
    if (typev==1) {
        [dict setValue:@"qq" forKey:@"type"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"nick_name"]] replaceNullString] forKey:@"nick_name"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"user_face"]] replaceNullString] forKey:@"user_face"];
        [dict setValue:[[NSString stringWithFormat:@"%@",[message objectForKey:@"third_id"]] replaceNullString] forKey:@"third_id"];
    }else if (typev==2)
    {
        dict = [NSMutableDictionary dictionaryWithDictionary:message];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict,@"credentials",@"wechat",@"type", nil];
        request = [[XjfRequest alloc]initWithAPIName:third_login RequestMethod:POST];
        request.requestParams = params;
    }else if (typev==3)
    {
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
    if (request) {
        [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
            RegistFinalModel *model = [[RegistFinalModel alloc]initWithData:responseData error:nil];
            if (model.errCode == 0) {
                SendNotification(loginSuccess, model);
            }else {
                NSLog(@"第三方登录失败--error:%@",model.errMsg);
            }
        } failedBlock:^(NSError * _Nullable error) {
            NSLog(@"第三方登录失败");
        }];
    }
}

- (void)btnLoginAction
{
    if (!([self.txtNickname.text isValidEmail] || [self.txtNickname.text isValidPhoneNumber])) {
        [[ZToastManager ShardInstance] showtoast:@"请输入正确的邮箱地址/手机号码"];
        return;
    }
    if(self.txtPass.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    [dict setValue:self.secure_key forKey:@"secure_key"];
    [dict setValue:self.secure_code forKey:@"secure_code"];
    [dict setValue:self.txtNickname.text forKey:@"username"];
    [dict setValue:self.txtPass.text forKey:@"password"];
    [self requestData:local_login method:POST params:dict];
    
}

#pragma mark - TextFiled Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.txtNickname) {
        [self.txtPass becomeFirstResponder];
    }else  if (textField==self.txtPass){
        
        [self.txtCode becomeFirstResponder];
    }else
    {
        [self btnLoginAction];
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)requestData:(APIName *)api method:(RequestMethod)method params:(NSMutableDictionary *)params{
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    if (params) {
        request.requestParams = params;
    }
    __weak typeof (self) wSelf = self;
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        [[ZToastManager ShardInstance]hideprogress];
        if ([api isEqualToString:local_login]) {
            RegistFinalModel *model = [[RegistFinalModel alloc]initWithData:responseData error:nil];
            if (model.errCode == 0) {
                SendNotification(loginSuccess, model);
            }else {
                [[ZToastManager ShardInstance]showtoast:model.errMsg];
            }
        }
        if ([api isEqualToString:get_image_code]) {
            ImageCodeModel *model = [[ImageCodeModel alloc]initWithData:responseData error:nil];
            NSURL *url = [NSURL URLWithString:model.result.secure_image];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *ret = [UIImage imageWithData:imageData];
            wSelf.secure_key = model.result.secure_key;
            wSelf.secure_code = model.result.secure_code;
            self.codeImageView.image = ret;
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance]hideprogress];
        [[ZToastManager ShardInstance]showtoast:@"请求失败"];
    }];
    
}
#pragma mark - UserDelegate
-(void)userRegistOK:(id)userInfo {
    
}
- (void)userRegistFail {
    
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
