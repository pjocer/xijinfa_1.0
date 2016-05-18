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
@property (nonatomic, strong) UILabel *lessonDescribe;

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
    
    self.lessonDescribe = [[UILabel alloc] init];
    [self.view addSubview:self.lessonDescribe];
    self.lessonDescribe.font = FONT12;
    self.lessonDescribe.text = @"xxxxxxxxxxxxxxxxxxxxxx";
    self.lessonDescribe.textColor = AssistColor
    [self.lessonDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.lessonName.mas_bottom).with.offset(10);
        make.height.mas_equalTo(18);
    }];
    
}


@end
