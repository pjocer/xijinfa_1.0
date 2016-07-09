//
//  BaseViewController.h
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xjfConfigure.h"
#import "Masonry.h"
#import "BaseViewCell.h"
#import "ZToastManager.h"
#import "LoadingView.h"

//为首界面设置HeaderView
FOUNDATION_EXTERN NSString *const Index;
FOUNDATION_EXTERN NSString *const My;
FOUNDATION_EXTERN NSString *const Topic;
FOUNDATION_EXTERN NSString *const Vip;
FOUNDATION_EXTERN NSString *const Subscribe;
FOUNDATION_EXTERN NSString *const Study;

@interface BaseViewController : UIViewController <LoadingDelegate>
@property (nonatomic, strong) LoadingView *loadingView;

- (void)showLoading;
- (void)showLoadingWithFrame:(CGRect)frame;
- (void)showLoadingFailed;
- (void)showLoadingFailedWithErrorType:(ErrorType)errorType;
- (void)showLoadingEmptyWithType:(EmptyType)type;
- (void)dismissLoading;

- (void)extendheadViewFor:(NSString *)name;

- (void)LoginPrompt;

@end
