//
//  myConfigure.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SettingViewController.h"
#import "UserUnLoadCell.h"

@protocol UserComponentCellDelegate <NSObject>

- (void)componentDidSelected:(NSUInteger)index;

@end