//
//  NewSharpViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NewSharpViewController.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import "XJMarket.h"

@interface NewSharpViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation NewSharpViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textFiled becomeFirstResponder];
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
    
    CGFloat all = 0;
    CGFloat alll = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat tap = 10;
    NSArray *labels = [[XJMarket sharedMarket] recentlyUsedLabels];
    for (int i = 0; i < labels.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"#%@#",labels[i]];
        CGSize size = [title sizeWithFont:FONT12 constrainedToSize:CGSizeMake(SCREENWITH, 14) lineBreakMode:1];
        all = all + tap + size.width;
        if (all <= SCREENWITH) {
            x = all - size.width;
            y = 74+18+10;
            button.frame = CGRectMake(x, y, size.width, 14);
        }else if (all <= SCREENWITH*2 && all>SCREENWITH) {
            alll = alll + tap + size.width;
            if (alll <= SCREENWITH) {
                x = alll - size.width;
                y = 74+18+10+24;
                button.frame = CGRectMake(x, y, size.width, 14);
            }else {
                return;
            }
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xjfStringToColor:@"#0061B0"] forState:UIControlStateNormal];
        button.titleLabel.font = FONT12;
        button.tag = 480+i;
        [button addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
- (void)labelClicked:(UIButton *)button {
    NSArray *labels = [[XJMarket sharedMarket] recentlyUsedLabels];
    _textFiled.text = [labels objectAtIndex:button.tag-480];
}
- (void)sendAction:(UIBarButtonItem *)item {
    [self.textFiled resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITextField *)textFiled {
    if (!_textFiled) {
        [_textFiled becomeFirstResponder];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length>9) {
        [[ZToastManager ShardInstance] showtoast:@"话题内容太长"];
        return NO;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:topic_all RequestMethod:POST];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":self.topicTag==1?@"qa":@"discuss",@"content":_textFiled.text}];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"errCode"] integerValue] == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(newSharpAddSuccessed:)]) {
                [self.delegate newSharpAddSuccessed:_textFiled.text];
            }
            [[XJMarket sharedMarket] addLabels:_textFiled.text];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
    return YES;
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
