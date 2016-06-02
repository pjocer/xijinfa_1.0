//
//  NewTopicViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NewTopicViewController.h"
#import "NotificationUtil.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZToastManager.h"
#import "XjfRequest.h"

@interface NewTopicViewController ()
@property (nonatomic, strong)UIButton *checkout;
@property (nonatomic, strong)UIButton *titleView_button;
@property (nonatomic, strong)UIButton *topic_new;
@property (nonatomic, strong)UIView *bottom;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *placeholder;
@end

@implementation NewTopicViewController

-(instancetype)initWithStyle:(NewTopicStyle)style {
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self obeserValues];
}

- (void)obeserValues {
    ReceivedNotification(self, UIKeyboardDidChangeFrameNotification, ^(NSNotification *notification) {
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat y = value.CGRectValue.origin.y-114;
        _bottom.frame = CGRectMake(0, y, SCREENWITH, 50);
    });
    [[self.textView rac_textSignal] subscribeNext:^(NSString *x) {
        if (![x isEqualToString:@""])_placeholder.hidden = YES;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
        _textView.attributedText = [[NSAttributedString alloc] initWithString:_textView.text attributes:attributes];
    }];
}

- (void)initMainUI {
    [self initNavBar];
    [self.view addSubview:self.bottom];
    [self.view addSubview:self.textView];
}
-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 8, SCREENWITH-20, SCREENHEIGHT-50-HEADHEIGHT-258)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = FONT15;
        _textView.textColor = NormalColor;
        [_textView becomeFirstResponder];
        [_textView addSubview:self.placeholder];
    }
    return _textView;
}
-(UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENWITH-20, 21)];
        _placeholder.text = @"谈谈你的想法吧~";
        _placeholder.textColor = AssistColor;
        _placeholder.font = FONT15;
    }
    return _placeholder;
}

-(UIView *)bottom {
    if (!_bottom) {
        _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-HEADHEIGHT-50, SCREENWITH, 50)];
        _bottom.backgroundColor = [UIColor whiteColor];
        [_bottom addSubview:self.topic_new];
    }
    return _bottom;
}

-(UIButton *)topic_new {
    if (!_topic_new) {
        _topic_new = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topic_new setBackgroundImage:[UIImage imageNamed:@"new_topic"] forState:UIControlStateNormal];
        _topic_new.frame = CGRectMake(SCREENWITH-32, 14, 22, 22);
        [_topic_new addTarget:self action:@selector(newTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topic_new;
}

-(UIButton *)checkout {
    if (!_checkout) {
        _checkout = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkout.backgroundColor = [UIColor whiteColor];
        _checkout.layer.cornerRadius = 5;
        _checkout.titleLabel.font = FONT(17);
        [_checkout setTitle:_style==NewTopicQAStyle?@"新讨论":@"新问答" forState:UIControlStateNormal];
        [_checkout setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
        _checkout.frame = CGRectMake(SCREENWITH/2-50, -50, 100, 50);
        _checkout.alpha = 0;
        [_checkout addTarget:self action:@selector(changeNewTopicStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkout;
}

-(UIButton *)titleView_button {
    if (!_titleView_button) {
        _titleView_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView_button.frame = CGRectMake(0, 0, 51, 18);
        [_titleView_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _titleView_button.titleLabel.font = FONT(17);
        [_titleView_button setTitle:_style==NewTopicQAStyle?@"新问答":@"新讨论" forState:UIControlStateNormal];
        [_titleView_button addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleView_button;
}

- (void)initNavBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    UIBarButtonItem *cancel_item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleClicked:)];
    UIBarButtonItem *send_item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClicked:)];
    cancel_item.tintColor = [UIColor whiteColor];
    send_item.tintColor = [UIColor whiteColor];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 71.5, 18)];
    [titleView addSubview:self.titleView_button];
    UIImageView *titleView_image = [[UIImageView alloc] initWithFrame:CGRectMake(61.5, 6, 10, 6)];
    titleView_image.image = [UIImage imageNamed:@"arrow_tip"];
    [titleView addSubview:titleView_image];
    titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
    [titleView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = cancel_item;
    self.navigationItem.rightBarButtonItem = send_item;
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.barTintColor = _style==NewTopicQAStyle?[UIColor blueColor]:[UIColor orangeColor];
}

- (void)resetNavBar {
    self.navigationController.navigationBar.barTintColor = _style==NewTopicQAStyle?[UIColor xjfStringToColor:@"#3fa9f5"]:[UIColor xjfStringToColor:@"#f7931e"];
    [_titleView_button setTitle:_style==NewTopicQAStyle?@"新问答":@"新讨论" forState:UIControlStateNormal];
}
- (void)checkoutShow {
    [UIView animateWithDuration:0.3 animations:^{
        _checkout.alpha = 1;
        _checkout.frame = CGRectMake(SCREENWITH/2-50, 10, 100, 50);
    }];
}
- (void)checkoutHidden {
    [UIView animateWithDuration:0.3 animations:^{
        _checkout.alpha = 0;
        _checkout.frame = CGRectMake(SCREENWITH/2-50, -50, 100, 50);
    } completion:^(BOOL finished) {
        _checkout = nil;
    }];
}

- (void)changeNewTopicStyle:(UIButton *)button {
    _style = _style==NewTopicQAStyle?NewTopicDiscussStyle:NewTopicQAStyle;
    [self checkoutHidden];
    [self resetNavBar];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self checkoutHidden];
    
}
- (void)headerViewClicked:(UITapGestureRecognizer *)gesture {
    if (_checkout == nil) {
        [self.view addSubview:self.checkout];
        [self checkoutShow];
    }else {
        [self checkoutHidden];
    }
}
- (void)newTopic:(UIButton *)button {
    NSLog(@"新话题");
}
- (void)cancleClicked:(UIBarButtonItem *)item {
    [self checkoutHidden];
    [_textView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClicked:(UIBarButtonItem *)item {
    if (_textView.text.length>140) {
        [[ZToastManager ShardInstance] showtoast:@"内容长度超出了140字"];
        return;
    }
    if (_textView.text.length == 0) {
        [[ZToastManager ShardInstance] showtoast:@"内容不能为空"];
        return;
    }
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:topic_all RequestMethod:POST];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":_style==NewTopicQAStyle?@"qa":@"discuss",@"content":_textView.text}];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"errCode"] integerValue] == 0) {
            [[ZToastManager ShardInstance] showtoast:@"发表成功"];
            [_textView resignFirstResponder];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
        }
        [[ZToastManager ShardInstance] hideprogress];
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络请求失败"];
        [[ZToastManager ShardInstance] hideprogress];
    }];
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
