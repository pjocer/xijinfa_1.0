//
//  UserInfoInterestedCell.m
//  xjf
//
//  Created by PerryJ on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoInterestedCell.h"

@implementation UserInfoInterestedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectMark.layer.borderColor = [[UIColor xjfStringToColor:@"#9a9a9a"] CGColor];
    self.selectMark.layer.cornerRadius = 7;
    self.selectMark.layer.borderWidth = 1;
    self.selectMark.layer.masksToBounds = YES;
}

- (void)resetMarkSelected:(void (^)(NSString *))selected cancelSelected:(void (^)(NSString *))deSelected {
    if (self.selectMark.layer.borderWidth != 1) {
        [self makeDeSelected];
        if (deSelected) deSelected(self.content.text);
    } else {
        [self makeSelected];
        if (selected) selected(self.content.text);
    }
}

- (void)makeSelected {
    self.selectMark.layer.borderWidth = 0;
    self.selectMark.layer.borderColor = nil;
    self.selectMark.backgroundColor = BlueColor;
}

- (void)makeDeSelected {
    self.selectMark.layer.borderColor = [[UIColor xjfStringToColor:@"#9a9a9a"] CGColor];
    self.selectMark.layer.borderWidth = 1;
    self.selectMark.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
