//
//  SettingRowOneCell.m
//  xjf
//
//  Created by PerryJ on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SettingRowOneCell.h"

@interface SettingRowOneCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@end

@implementation SettingRowOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        NSLog(@"开启");
    } else {
        NSLog(@"关闭");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
