//
//  UserUnLoadCell.m
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserUnLoadCell.h"

@implementation UserUnLoadCell
{
    __weak IBOutlet UILabel *bottomLine;
    __weak IBOutlet UIImageView *icon;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    bottomLine.backgroundColor = BackgroundColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
