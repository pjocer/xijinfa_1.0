//
//  PayView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJMarket.h"

@class PayView;
@protocol PayViewDelegate <NSObject>
- (void)payView:(PayView *)payView DidSelectedBy:(PayStyle)type;
@end

@interface PayView : UIView
+ (void)showWithTarget:(id<PayViewDelegate>)target;
@end