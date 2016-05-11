//
//  UserThirdLogin.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserThirdLogin.h"

@interface UserThirdLogin ()<UITextFieldDelegate>
{
    
}
@property (weak) id<UserDelegate> delegate;
@property(nonatomic,strong) NSDictionary     *userinfo;
@property(nonatomic,strong) UITextField     *txtUser;
@property(nonatomic,strong)void(^actionBlock)(id,id);
+ (instancetype)newController;
@end

@implementation UserThirdLogin
+ (instancetype)newController
{
    return [super new];
}

+ (instancetype)newWithDelegate:(id<UserDelegate>)delegate userinfo:(NSDictionary*)userinfo
{
    UserThirdLogin *viewController = [UserThirdLogin newController];
    
    if (viewController) {
        viewController.delegate = delegate;
        viewController.userinfo= userinfo;
    }
    
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.txtUser.frame =CGRectMake(PHOTO_FRAME_WIDTH*2, 100, SCREENWITH-PHOTO_FRAME_WIDTH*4, PHOTO_FRAME_WIDTH*4);
    self.txtUser.text =[self.userinfo objectForKey:@"nick_name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.actionBlock=nil;
    [self.txtUser resignFirstResponder];
    self.txtUser=nil;
    DLog(@"%s", __PRETTY_FUNCTION__);
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
            [self.txtUser resignFirstResponder];
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
        case 1:
        {
            [self okAction];
        }
            break;
        default:
            break;
    }
}
-(UITextField *)txtUser
{
    if (!_txtUser) {
        self.txtUser = [[UITextField alloc] initWithFrame:CGRectZero];
        self.txtUser.placeholder = @" 用户昵称";
        [self.txtUser setBorderStyle:UITextBorderStyleRoundedRect];
        self.txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtUser.font = FONT(13);
        self.txtUser.autocorrectionType = UITextAutocorrectionTypeNo;
        self.txtUser.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.txtUser.returnKeyType = UIReturnKeyNext;
        self.txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.txtUser.delegate=self;
        [self.txtUser becomeFirstResponder];
        [self.view addSubview:self.txtUser];
    }
    return _txtUser;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)okAction
{
    if (self.txtUser.text.length==0) {
        return;
    }
    [self.txtUser resignFirstResponder];
   
    
}

@end
