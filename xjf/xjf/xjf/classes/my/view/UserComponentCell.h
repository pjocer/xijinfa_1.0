//
//  UserComponentCell.h
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myConfigure.h"

@protocol UserComponentCellDelegate <NSObject>

- (void)componentDidSelected:(NSUInteger)index;

@end

@interface UserComponentCell : UITableViewCell

@property (nonatomic, weak) id <UserComponentCellDelegate> delegate;

@end
