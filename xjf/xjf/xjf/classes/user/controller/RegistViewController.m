//
//  RegistViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RegistViewController.h"
#import "PasswordSettingViewController.h"
#import "XjfRequest.h"

@interface RegistViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtCodePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCodeImage;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation RegistViewController
+ (instancetype)newController
{
    return [super new];
}
+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate
{
    RegistViewController *viewController = [RegistViewController newController];
    if (viewController) {
        viewController.delegate = delegate;
    }
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeImage.layer.cornerRadius = 5;
    self.codeImage.backgroundColor = NormalColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCodeImage:)];
    [self.codeImage addGestureRecognizer:tap];
    self.codeButton.layer.cornerRadius = 5;
    self.nextButton.layer.cornerRadius = 5;
    self.txtCodePhone.delegate = self;
    self.txtCodeImage.delegate = self;
    self.txtPhone.delegate = self;
    
}
-(void)setTitle_item:(NSString *)title_item {
    _title_item = title_item;
    self.navigationItem.title = title_item;
}
//点击更换图片验证码
- (void)changeCodeImage:(UITapGestureRecognizer *)gesture {
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:get_image_code RequestMethod:GET];
    [request startWithSuccessBlock:^(NSDictionary * _Nullable responseData) {
        NSLog(@"%@",responseData);
    } failedBlock:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)codeButtonClicked:(UIButton *)sender {
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:regist_message_code RequestMethod:POST];
    [request startWithSuccessBlock:^(id  _Nullable responseData) {
        NSLog(@"%@",responseData);
    } failedBlock:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)nextButtonClicked:(UIButton *)sender {
    if(self.txtPhone.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入手机号码"];
        return;
    }
    if(self.txtCodeImage.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入图片验证码"];
        return;
    }
    if (self.txtCodePhone.text.length==0) {
        [[ZToastManager ShardInstance] showtoast:@"请输入手机验证码"];
        return;
    }
    [[ZToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    
    
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    [dict setValue:@"login" forKey:@"hadLogin"];
    [dict setValue:self.txtPhone.text forKey:@"username"];
    
    PasswordSettingViewController *password = [[PasswordSettingViewController alloc]init];
    if ([self.title_item isEqualToString:@"注册"]) {
        password.itemTitle = @"设置密码";
    }else {
        password.itemTitle = @"重设密码";
    }
    [self.navigationController pushViewController:password animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextFiled Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.txtPhone) {
        [self.txtCodeImage becomeFirstResponder];
    }else  if (textField==self.txtCodeImage){
        [self.txtCodePhone becomeFirstResponder];
    }else
    {
        [self nextButtonClicked:self.nextButton];
        [textField resignFirstResponder];
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
