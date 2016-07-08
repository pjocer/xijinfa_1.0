//
//  PayView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJMarket.h"
@class TalkGridModel;
@class PayView;
@protocol PayViewDelegate <NSObject>
- (id)paramsForCurrentpayView:(PayView *)payView;
- (void)payViewDidPaySuccessed:(PayView *)payView;
- (void)payViewDidPayFailed:(PayView *)payView;
@optional
- (void)payView:(PayView *)payView DidSelectedBy:(PayStyle)type;
- (void)payViewDidCanceled:(PayView *)payView;
@end

typedef enum : NSUInteger {
    PayViewDefault,
    PayViewWithoutBalance,
} PayViewType;

@interface PayView : UIView
+ (void)showWithTarget:(id<PayViewDelegate>)target type:(PayViewType)type;
@end