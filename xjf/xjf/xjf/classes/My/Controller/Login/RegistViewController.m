//
//  RegistViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RegistViewController.h"
#import "PasswordSettingViewController.h"
#import "XJRequest.h"

@interface RegistViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITextField *txtCodePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCodeImage;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) ImageCode *model;
@property (assign, nonatomic) BOOL phoneIsOK;
@property (assign, nonatomic) BOOL imageCodeIsOk;
@property (assign, nonatomic) BOOL codeIsOk;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation RegistViewController {
    NSInteger _timecount;
}
+ (instancetype)newController {
    return [super new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _title_item;
    self.codeImage.layer.cornerRadius = 5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCodeImage:)];
    [self.codeImage addGestureRecognizer:tap];
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.enabled = NO;
    self.codeButton.backgroundColor = self.codeButton.enabled ? [UIColor xjfStringToColor:@"#0061b0"] : SegementColor;
    self.txtCodePhone.delegate = self;
    self.txtCodeImage.delegate = self;
    self.txtPhone.delegate = self;
    @weakify(self)
    [[[self.txtCodePhone rac_signalForControlEvents:UIControlEventEditingChanged] filter:^BOOL(NSString *value) {
        if (self.txtCodePhone.text.length == 6 && self.txtCodeImage.text.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self requestData:check_code_message method:POST];
    }];
    [[[self.txtCodeImage rac_signalForControlEvents:UIControlEventEditingDidEnd] filter:^BOOL(id value) {
        if (self.txtCodeImage.text.length == 6) {
            return YES;
        } else {
            return NO;
        }
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self requestData:check_image_code method:POST];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData:get_image_code method:GET];
}

//点击更换图片验证码
- (void)changeCodeImage:(UITapGestureRecognizer *)gesture {
    [self requestData:get_image_code method:GET];
}

- (IBAction)codeButtonClicked:(UIButton *)sender {
    self.codeIsOk = YES;
    [self requestData:[self.title_item isEqualToString:@"注册"] ? regist_message_code : reset_message_code method:POST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    [XJRequest requestData:api method:method params:^NSDictionary *{
        if ([api isEqualToString:regist_message_code] || [api isEqualToString:reset_message_code]) {
            return @{@"phone":wSelf.txtPhone.text,@"secure_code":wSelf.txtCodeImage.text,@"secure_key":wSelf.model.secure_key};
        } else if ([api isEqualToString:check_code_message]) {
            return @{@"phone":wSelf.txtPhone.text,@"code":wSelf.txtCodePhone.text};
        }
        return nil;
    } success:^(XJRequest *request) {
        if ([api isEqualToString:get_image_code]) {
            [wSelf.indicator stopAnimating];
            ImageCode *code = [[ImageCode alloc] initWithDictionary:request.result error:nil];
            NSLog(@"%@",code);
            wSelf.model = [[ImageCode alloc] initWithDictionary:request.result error:nil];
            NSLog(@"%@",wSelf.model);
            NSURL *url = [NSURL URLWithString:wSelf.model.secure_image];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *ret = [UIImage imageWithData:imageData];
            wSelf.codeImage.image = ret;
        } else if ([api isEqualToString:regist_message_code] || [api isEqualToString:reset_message_code]) {
            if (request.errCode == 0) {
                [[ZToastManager ShardInstance] showtoast:@"发送验证码成功"];
            } else {
                [[ZToastManager ShardInstance] showtoast:request.errMsg];
            }
            self.codeButton.enabled = NO;
            self.codeButton.backgroundColor = SegementColor;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setValidateBtnTitle) userInfo:nil repeats:YES];
            [self.timer fire];
        } else if ([api isEqualToString:check_code_message]) {
            [self.txtCodePhone resignFirstResponder];
            if (request.errCode == 0) {
                [[ZToastManager ShardInstance] showtoast:@"验证码正确"];
                [_timer invalidate];
                _timer = nil;
                _timecount = 0;
                self.codeButton.enabled = YES;
                self.codeButton.backgroundColor = PrimaryColor;
                PasswordSettingViewController *controller = [[PasswordSettingViewController alloc] init];
                controller.itemTitle = [self.title_item isEqualToString:@"注册"] ? @"设置密码" : @"重设密码";
                controller.dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:wSelf.txtPhone.text, @"phone", wSelf.txtCodePhone.text, @"code", nil];
                [wSelf.navigationController pushViewController:controller animated:YES];
            } else {
                [[ZToastManager ShardInstance] showtoast:request.errMsg];
            }
        } else if ([api isEqualToString:check_image_code]) {
            if (request.errCode == 0) {
                self.imageCodeIsOk = YES;
                [self setCodeButtonStatus];
            } else {
                [[ZToastManager ShardInstance] showtoast:request.errMsg];
            }
        }
    } failed:nil];
}

- (void)setValidateBtnTitle {
    _timecount++;
    if (_timecount >= 60) {
        [_timer invalidate];
        _timer = nil;
        _timecount = 0;
        self.codeButton.enabled = YES;
        self.codeButton.backgroundColor = PrimaryColor;
    } else {
        self.codeButton.enabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"倒计时:%lis", 60 - _timecount] forState:UIControlStateDisabled];
    }
}

#pragma mark - TextFiled Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.txtPhone) {
        [self.txtCodeImage becomeFirstResponder];
    } else if (textField == self.txtCodeImage) {
        [self.txtCodePhone becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.txtPhone) {
        if ([self.txtPhone.text isValidEmail] || [textField.text isValidPhoneNumber]) {
            self.phoneIsOK = YES;
        } else {
            [[ZToastManager ShardInstance] showtoast:@"请输入正确的手机号码"];
        }
    }
}

- (void)setCodeButtonStatus {
    if (!self.codeIsOk) {
        self.codeButton.enabled = self.phoneIsOK && self.imageCodeIsOk;
    }
    self.codeButton.backgroundColor = self.codeButton.enabled ? [UIColor xjfStringToColor:@"#0061b0"] : SegementColor;
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
