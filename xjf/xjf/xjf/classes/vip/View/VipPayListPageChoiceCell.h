//
//  VipPayListPageChoiceCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipModel.h"
@interface VipPayListPageChoiceCell : UITableViewCell
@property (nonatomic, strong) VipModel *model;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *backGroudView;
@end
