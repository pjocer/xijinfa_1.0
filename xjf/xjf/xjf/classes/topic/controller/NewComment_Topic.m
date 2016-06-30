//
//  NewCommentViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NewComment_Topic.h"
#import "ZToastManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XjfRequest.h"

@interface NewComment_Topic ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, assign) NewStyle style;
@end

@implementation NewComment_Topic

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
-(instancetype)initWithType:(NewStyle)aNewStyle {
    if (self = [super init]) {
        _style = aNewStyle;
    }
    return self;
}
- (void)initMainUI {
    UIBarButtonItem *cancel_item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleClicked:)];
    cancel_item.tintColor = NormalColor;
    UIBarButtonItem *send_item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClicked:)];
    send_item.tintColor = NormalColor;
    self.navigationItem.leftBarButtonItem = cancel_item;
    self.navigationItem.rightBarButtonItem = send_item;
    [self.view addSubview:self.textView];
    self.nav_title = self.style==NewTopic?@"新增话题":@"新增评论";
    [[self.textView rac_textSignal] subscribeNext:^(NSString *x) {
        if (![x isEqualToString:@""]) {
            _placeholder.hidden = YES;
        }
    }];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 8, SCREENWITH - 20, SCREENHEIGHT - HEADHEIGHT - 258)];
        _textView.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        NSDictionary *attributes = @{NSFontAttributeName : FONT15, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor xjfStringToColor:@"#444444"]};
        _textView.typingAttributes = attributes;
//        _textView.textColor = NormalColor;
        [_textView becomeFirstResponder];
        [_textView addSubview:self.placeholder];
    }
    return _textView;
}

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENWITH - 20, 21)];
        _placeholder.text = @"谈谈你的想法吧~";
        _placeholder.textColor = AssistColor;
        _placeholder.font = FONT15;
    }
    return _placeholder;
}

- (void)cancleClicked:(UIBarButtonItem *)item {
    [_textView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendClicked:(UIBarButtonItem *)item {
    if (_textView.text.length > 140) {
        [[ZToastManager ShardInstance] showtoast:@"内容长度超出了140字"];
        return;
    }
    if (_textView.text.length == 0) {
        [[ZToastManager ShardInstance] showtoast:@"内容不能为空"];
        return;
    }
    APIName *api = self.style == NewTopic?topic_all:[NSString stringWithFormat:@"%@%@/reply", topic_all, self.topic_id];
    NSDictionary *params = @{@"content" : _textView.text,@"client":@"ios",@"type":self.type};
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:POST];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"errCode"] integerValue] == 0) {
            [[ZToastManager ShardInstance] showtoast:@"发表成功"];
            [_textView resignFirstResponder];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络请求失败"];
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
