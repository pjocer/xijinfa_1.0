//
//  PasswordSettingViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PasswordSettingViewController.h"
#import "XjfRequest.h"

@interface PasswordSettingViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password_again;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation PasswordSettingViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ZToastManager ShardInstance] hideprogress];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 5;
    if (![self.itemTitle isEqualToString:@"设置密码"]) {
        self.password.placeholder = @"请输入您的新密码";
        self.password_again.placeholder = @"请再次输入您的新密码";
    }
}
-(void)setItemTitle:(NSString *)itemTitle {
    _itemTitle = itemTitle;
    self.navigationItem.title = itemTitle;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonClicked:(UIButton *)sender {
    if(self.password.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请输入密码"];
        return;
    }
    if(self.password_again.text.length==0)
    {
        [[ZToastManager ShardInstance] showtoast:@"请再次输入您的密码"];
        return;
    }
    if (![self.password.text isEqualToString:self.password_again.text])
    {
        [[ZToastManager ShardInstance] showtoast:@"密码不一致"];
        return;
    }
    [[ZToastManager ShardInstance] showprogress];
    if ([self.itemTitle isEqualToString:@"重设密码"]) {
        XjfRequest *request = [[XjfRequest alloc]initWithAPIName:reset_password RequestMethod:POST];
        [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
            
        } failedBlock:^(NSError * _Nullable error) {
            
        }];
    }
    if ([self.itemTitle isEqualToString:@"设置密码"]) {
//        XjfRequest *request = [XjfRequest alloc]initWithAPIName:<#(nonnull APIName *)#> RequestMethod:<#(RequestMethod)#>
    }
    __weak typeof (self) wSelf = self;
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    
    [dict setValue:@"login" forKey:@"hadLogin"];
    [dict setValue:self.password.text forKey:@"password"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - TextFiled Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.password) {
        [self.password_again becomeFirstResponder];
    }else  if (textField==self.password_again){
        [self nextButtonClicked:self.nextButton];
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
