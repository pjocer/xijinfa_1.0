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
- (void)payView:(PayView *)payView DidSelectedBy:(PayStyle)type;
@optional
- (NSDictionary *)paramsForCurrentpayView:(PayView *)payView;
- (NSArray <TalkGridModel *>*)tradesForCurrentpayView:(PayView *)payView;
@end

@interface PayView : UIView
+ (void)showWithTarget:(id<PayViewDelegate>)target;
@end