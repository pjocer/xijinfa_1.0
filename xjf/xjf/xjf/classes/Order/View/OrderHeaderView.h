//
//  OrderHeaderView.h
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderHeaderView : UIView
@property (nonatomic, strong) UILabel *orderNumber;
@property (nonatomic, strong) UILabel *orderDate;
@property (nonatomic, strong) OrderDataModel *model;
@end
