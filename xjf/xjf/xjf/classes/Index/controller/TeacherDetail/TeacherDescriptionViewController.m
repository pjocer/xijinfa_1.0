//
//  TeacherDescriptionViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherDescriptionViewController.h"
@interface TeacherDescriptionViewController ()

@end

@implementation TeacherDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self wetWKWebView];
    
}

- (void)wetWKWebView
{
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.web];
}

@end
