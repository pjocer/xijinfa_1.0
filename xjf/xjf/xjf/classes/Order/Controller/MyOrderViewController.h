//
//  MyOrderViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderDetailBaseViewController.h"

@interface MyOrderViewController : OrderDetailBaseViewController
- (void)requestAllOrderData:(APIName *)api method:(RequestMethod)method;
@property (nonatomic, strong) NSDictionary *requestParams;
@end
