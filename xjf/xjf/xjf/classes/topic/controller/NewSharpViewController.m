//
//  NewSharpViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NewSharpViewController.h"
#import "XjfRequest.h"

@interface NewSharpViewController ()
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation NewSharpViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
- (void)initMainUI {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 64)];
    header.backgroundColor = [UIColor whiteColor];
    [header addSubview:self.textFiled];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(SCREENWITH-40, 5+kStatusBarH, 30, 30);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = FONT15;
    [cancel setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    [self.view addSubview:header];
    
    UILabel *recently = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 60, 18)];
    recently.font = FONT15;
    recently.textColor = NormalColor;
    recently.text = @"最近使用";
    [self.view addSubview:recently];
    
    
    
}
- (void)sendAction:(UIBarButtonItem *)item {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:topic_all RequestMethod:POST];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":self.topicTag==1?@"qa":@"discuss",@"content":_textFiled.text}];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        
    } failedBlock:^(NSError * _Nullable error) {
        
    }];
}
-(UITextField *)textFiled {
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(10,kStatusBarH+5, SCREENWITH-60, 30)];
        _textFiled.placeholder = @"# 输入话题";
        _textFiled.borderStyle = UITextBorderStyleRoundedRect;
        _textFiled.backgroundColor = BackgroundColor;
        _textFiled.font = FONT15;
        [_textFiled setReturnKeyType:UIReturnKeyDone];
        _textFiled.delegate = self;
        _textFiled.textColor = NormalColor;
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textFiled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
