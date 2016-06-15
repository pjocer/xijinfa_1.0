//
//  FeedbackView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "FeedbackView.h"

@implementation FeedbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //scrolleView
        self.scrolleView = [[UIScrollView alloc] init];
        self.scrolleView.frame = self.bounds;
        [self addSubview:self.scrolleView];
        self.scrolleView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height + 30);
        self.scrolleView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.scrolleView.showsVerticalScrollIndicator = NO;
        
        //feedbackTextView
        self.feedbackTextView = [[CloverText alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, SCREENHEIGHT / 5 * 2) placeholder:@" 输入你的反馈信息"];
        self.feedbackTextView.font = FONT15;
        [self.scrolleView addSubview:self.feedbackTextView];
        self.feedbackTextView.backgroundColor = [UIColor whiteColor];

        //qqTextField
        self.qqTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(self.feedbackTextView.frame.origin.x, CGRectGetMaxY(self.feedbackTextView.frame) + 10, self.feedbackTextView.frame.size.width, 50)];
        [self.scrolleView addSubview:self.qqTextField];
        self.qqTextField.borderStyle = UITextBorderStyleNone;
        self.qqTextField.backgroundColor = [UIColor whiteColor];
        self.qqTextField.placeholder = @"您的QQ号码 (选填)";
        self.qqTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.qqTextField.returnKeyType = UIReturnKeyDone;
        
        //submit
        self.submit = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submit.frame = CGRectMake(self.feedbackTextView.frame.origin.x, CGRectGetMaxY(self.qqTextField.frame) + 10, self.feedbackTextView.frame.size.width, 50);
        self.submit.layer.cornerRadius = 5;
        self.submit.layer.masksToBounds = YES;
        self.submit.backgroundColor = BlueColor;
        self.submit.titleLabel.font = FONT15;
        [self.submit setTitle:@"提交" forState:UIControlStateNormal];
        [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submit addTarget:self action:@selector(dredgeVIP:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrolleView addSubview:self.submit];
    }
    return self;
}

- (void)dredgeVIP:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(FeedbackView:FeedAction:)]) {
        [self.delegate FeedbackView:self FeedAction:sender];
    }
}

@end
