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
    self.textView = [[UITextView alloc] init];
    [self.view addSubview: self.textView];
    self.textView.textColor = AssistColor
    self.textView.font = [UIFont fontWithName:@"Arial" size:12.0];
    //    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.scrollEnabled = YES;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.editable = NO;
    self.textView.text = self.tempContent;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(10);
        make.bottom.equalTo(self.view).with.offset(-60);
    }];
}




@end
