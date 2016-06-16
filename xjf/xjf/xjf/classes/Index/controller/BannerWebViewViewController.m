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
@property(strong, nonatomic) WKWebView *webView;
@property(nonatomic, strong) UIProgressView *progressView;
@end

@implementation BannerWebViewViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

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

    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 3)];
    [self.view addSubview:self.progressView];
    self.progressView.progressTintColor = BlueColor;
    self.progressView.trackTintColor = BackgroundColor;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREENWITH,
            SCREENHEIGHT - CGRectGetMaxY(self.progressView.frame))];
    [self.view addSubview:_webView];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webHtmlUrl]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webHtmlUrl]]];

    //监听进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];

}

/** 监听进度 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    self.progressView.progress = _webView.estimatedProgress;
    if (_webView.estimatedProgress > 0.6) {
        self.progressView.progress = 1;
        self.progressView.hidden = YES;
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}
@end
