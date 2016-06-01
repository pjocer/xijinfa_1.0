//
//  NewTopicViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NewTopicViewController.h"
#import "NotificationUtil.h"


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
    ReceivedNotification(self, UIKeyboardDidChangeFrameNotification, ^(NSNotification *notification) {
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat y = value.CGRectValue.origin.y-130;
        _bottom.frame = CGRectMake(0, y, SCREENWITH, 50);
        _placeholder.hidden = YES;
    });
}

- (void)initMainUI {
    [self initNavBar];
    [self.view addSubview:self.bottom];
    [self.view addSubview:self.textView];
}
-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREENWITH-20, SCREENHEIGHT-50-HEADHEIGHT)];
        _textView.backgroundColor = [UIColor clearColor];
        [_textView addSubview:self.placeholder];
    }
    return _textView;
}
-(UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH-20, 21)];
        _placeholder.text = @"谈谈你的想法吧~";
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
        [_topic_new setTitle:@"#" forState:UIControlStateNormal];
        _topic_new.frame = CGRectMake(SCREENWITH-50, 5, 40, 40);
        [_topic_new setTitleColor:[UIColor xjfStringToColor:@"#9a9a9a"] forState:UIControlStateNormal];
        _topic_new.titleLabel.font = FONT(39);
        [_topic_new addTarget:self action:@selector(newTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topic_new;
}

-(UIButton *)checkout {
    if (!_checkout) {
        _checkout = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkout.backgroundColor = [UIColor whiteColor];
        _checkout.layer.cornerRadius = 5;
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
    self.navigationController.navigationBar.barTintColor = _style==NewTopicQAStyle?[UIColor blueColor]:[UIColor orangeColor];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClicked:(UIBarButtonItem *)item {
    
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
