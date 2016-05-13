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
#import "ImageCodeModel.h"

@interface RegistViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITextField *txtCodePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCodeImage;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) ImageCodeModel *model;
@property (assign, nonatomic) BOOL phoneIsOK;
@property (assign, nonatomic) BOOL imageCodeIsOk;
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
    self.codeButton.enabled = NO;
    self.codeButton.backgroundColor = self.codeButton.enabled?[UIColor xjfStringToColor:@"#0061b0"]:SegementColor;
    self.txtCodePhone.delegate = self;
    self.txtCodeImage.delegate = self;
    self.txtPhone.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData:get_image_code method:GET];
}

-(void)setTitle_item:(NSString *)title_item {
    _title_item = title_item;
    self.navigationItem.title = title_item;
}
//点击更换图片验证码
- (void)changeCodeImage:(UITapGestureRecognizer *)gesture {
    [self requestData:get_image_code method:GET];
}
- (IBAction)codeButtonClicked:(UIButton *)sender {
    [self requestData:regist_message_code method:POST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(APIName *)api method:(RequestMethod)method{
    __weak typeof (self) wSelf = self;
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    if ([api isEqualToString:regist_message_code]) {
        [request.requestParams setObject:self.txtPhone.text forKey:@"phone"];
        [request.requestParams setObject:self.txtCodeImage.text forKey:@"secure_code"];
        [request.requestParams setObject:self.model.result.secure_key forKey:@"secure_key"];
    }
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        __strong typeof (self)sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        if ([api isEqualToString:get_image_code]) {
            [sSelf.indicator stopAnimating];
            sSelf.model = [[ImageCodeModel alloc]initWithData:responseData error:nil];
            NSURL *url = [NSURL URLWithString:sSelf.model.result.secure_image];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *ret = [UIImage imageWithData:imageData];
            sSelf.codeImage.image = ret;
        }else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic);
            ImageCodeModel *model = [[ImageCodeModel alloc]initWithData:responseData error:nil];
            NSLog(@"%@",model);
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance]showtoast:@"请求失败"];
    }];
}

#pragma mark - TextFiled Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.txtPhone) {
        [self.txtCodeImage becomeFirstResponder];
    }else  if (textField==self.txtCodeImage){
        [self.txtCodePhone becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==self.txtPhone) {
        if ([self.txtPhone.text isValidEmail] || [textField.text isValidPhoneNumber]) {
            self.phoneIsOK = YES;
        }else {
            [[ZToastManager ShardInstance] showtoast:@"请输入正确的手机号码"];
        }
    }else  if (textField==self.txtCodeImage){
        if ([textField.text isEqualToString:self.model.result.secure_code]) {
            self.imageCodeIsOk = YES;
        }else {
            [[ZToastManager ShardInstance] showtoast:@"请输入正确的图片验证码"];
        }
    }
    self.codeButton.enabled = self.phoneIsOK && self.imageCodeIsOk;
    self.codeButton.backgroundColor = self.codeButton.enabled?[UIColor xjfStringToColor:@"#0061b0"]:SegementColor;
    
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
