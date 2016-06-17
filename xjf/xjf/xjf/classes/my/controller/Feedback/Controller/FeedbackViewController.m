//
//  FeedbackViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackView.h"
#import "UserProfileModel.h"

@interface FeedbackViewController () <FeedbackViewDelegate>
@property (nonatomic, strong) FeedbackView *feedbackView;
@end

@implementation FeedbackViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"意见反馈";
}


- (void)loadView {
    [super loadView];
    self.feedbackView = [[FeedbackView alloc] initWithFrame:self.view.bounds];
    self.feedbackView.delegate = self;
    self.view = self.feedbackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - FeedbackViewDelegate

- (void)FeedbackView:(FeedbackView *)feedbackViewsub FeedAction:(UIButton *)sender {
    [self PostFeedMessageToSever:feedback Method:POST FeedbackView:feedbackViewsub FeedAction:sender];
}

- (void)PostFeedMessageToSever:(APIName *)api
                        Method:(RequestMethod)method
                  FeedbackView:(FeedbackView *)feedbackViewsub
                    FeedAction:(UIButton *)sender {
    UserProfileModel *userProfileModel = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname" : userProfileModel.result.nickname, @"contact" : feedbackViewsub.qqTextField.text, @"content" : feedbackViewsub.feedbackTextView.text}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        [[ZToastManager ShardInstance] showtoast:@"我们已收到您的反馈信息,谢谢!"];
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}


@end
