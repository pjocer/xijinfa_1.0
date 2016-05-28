//
//  OrderFooterView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFooterView : UIView
@property (nonatomic, strong) UILabel *orderStatus;
@property (nonatomic, strong) UILabel *orderDescription;
@property (nonatomic, strong) UIView *PaySuccesView;
@property (nonatomic, strong) UILabel *payStyle;
@property (nonatomic, strong) UILabel *payStyleName;
@property (nonatomic, assign) BOOL isPaySucces;
@end
