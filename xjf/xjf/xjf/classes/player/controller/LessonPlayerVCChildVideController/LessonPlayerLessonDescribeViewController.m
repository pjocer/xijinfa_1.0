//
//  LessonPlayerLessonDescribeViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonDescribeViewController.h"

@interface LessonPlayerLessonDescribeViewController ()

@end

@implementation LessonPlayerLessonDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self wetWKWebView];
}

- (void)wetWKWebView
{
    self.web = [[UIWebView alloc] init];
    [self.view addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).with.offset(10);
        make.bottom.right.equalTo(self.view).with.offset (-10);
    }];
    
    ViewRadius(self.web, 5);
    self.web.backgroundColor = [UIColor clearColor];
    [self.web loadHTMLString:self.contentText baseURL:nil];
}

- (void)setContentText:(NSString *)contentText
{
    if (contentText) {
        _contentText = contentText;
    }
   [self.web loadHTMLString:self.contentText baseURL:nil];
    
}

@end
