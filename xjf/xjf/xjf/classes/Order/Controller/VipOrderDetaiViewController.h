//
//  VipOrderDetaiViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "OrderDetailBaseViewController.h"
#import "VipModel.h"

@interface VipOrderDetaiViewController : OrderDetailBaseViewController
@property(nonatomic, strong) VipModel *vipModel;
@property(nonatomic, strong) NSMutableDictionary *dicData;
@end
