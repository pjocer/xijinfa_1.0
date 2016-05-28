//
//  MyOrderFooterView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderFooterView;

@protocol MyOrderFootrtViewDelegate <NSObject>

- (void) MyOrderFootrtView:(MyOrderFooterView *)orderFooterView
       goPayOrCancelOreder:(UIButton*)sender;

@end

@interface MyOrderFooterView : UIView
@property (nonatomic, strong) UILabel *orderStatus;
@property (nonatomic, strong) UILabel *orderDescription;
@property (nonatomic, strong) UIView *PayUnSuccesView;
@property (nonatomic, strong) UIButton *cancelOrder;
@property (nonatomic, strong) UIButton *goPay;
@property (nonatomic, assign) BOOL isPaySucces;
@property (nonatomic, assign) BOOL isOrderCancel;
@property (nonatomic, assign) id<MyOrderFootrtViewDelegate>delegate;
@end
