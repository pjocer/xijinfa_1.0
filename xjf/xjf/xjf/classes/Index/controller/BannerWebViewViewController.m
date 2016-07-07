//
//  BannerWebViewViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BannerWebViewViewController.h"
#import <WebKit/WebKit.h>

@interface BannerWebViewViewController ()
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation BannerWebViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWKWebView];
}

#pragma mark 返回

- (void)back:(UIBarButtonItem *)sender {
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 设置网络视图

- (void)setWKWebView {
    CGFloat progressViewH = 3;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, progressViewH)];
    [self.view addSubview:self.progressView];
    self.progressView.progressTintColor = BlueColor;
    self.progressView.trackTintColor = BackgroundColor;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.progressView.frame),
                                                               SCREENWITH,
                                                               SCREENHEIGHT - CGRectGetMaxY(self.progressView.frame))];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webHtmlUrl]]];

    @weakify(self)
    [RACObserve(_webView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self)
        self.progressView.progress = _webView.estimatedProgress;
        self.progressView.hidden = _webView.estimatedProgress == 1 ? YES : NO;
    }];
}

@end
