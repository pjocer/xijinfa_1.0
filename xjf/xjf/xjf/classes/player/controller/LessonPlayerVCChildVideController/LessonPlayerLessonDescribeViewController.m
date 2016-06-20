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
    self.view.backgroundColor = [UIColor whiteColor];
    [self wetWKWebView];
}

- (void)wetWKWebView
{
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.web];
    [self.web loadHTMLString:self.contentText baseURL:nil];
}

@end
