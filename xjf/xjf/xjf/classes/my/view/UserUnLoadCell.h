//
//  UserUnLoadCell.h
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CellTypeUnload,
    CellTypeLoadWithoutVIP,
    CellTypeLoadWithVIP,
} CellType;

@interface UserUnLoadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (assign, nonatomic) CellType type;
@end
