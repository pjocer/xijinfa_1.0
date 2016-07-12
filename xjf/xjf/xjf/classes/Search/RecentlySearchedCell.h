//
//  RecentlySearchedCell.h
//  xjf
//
//  Created by PerryJ on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentlySearchedCell : UITableViewCell
@property (nonatomic, copy) void (^searchHandler) (NSString *text);
@end
