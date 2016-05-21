//
//  LessonPlayerLessonDescribeViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonDescribeViewController.h"

@interface LessonPlayerLessonDescribeViewController ()
@property (nonatomic, strong) UILabel *lessonName;
@property (nonatomic, retain) UITextView *textView;
@end

@implementation LessonPlayerLessonDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.lessonName = [[UILabel alloc] init];
    [self.view addSubview:self.lessonName];
    self.lessonName.font = FONT15;
    self.lessonName.text = @"股票基础课程-XXXXXX";
    self.lessonName.textAlignment = NSTextAlignmentLeft;
    [self.lessonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: self.textView];
    self.textView.textColor = AssistColor
    self.textView.font = [UIFont fontWithName:@"Arial" size:12.0];
//    self.textView.delegate = self;//设置它的委托方法
    self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
    self.textView.scrollEnabled = YES;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.editable = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(10);
            make.right.equalTo(self.view).with.offset(-10);
            make.top.equalTo(self.lessonName.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.view).with.offset(-60);
        }];
}


@end
