//
//  OrderDetaiViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderDetailBaseViewController.h"
#import "OrderModel.h"
#import "XJOrder.h"

@interface OrderDetaiViewController : OrderDetailBaseViewController
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) OrderDataModel *orderDataModel;
@end
