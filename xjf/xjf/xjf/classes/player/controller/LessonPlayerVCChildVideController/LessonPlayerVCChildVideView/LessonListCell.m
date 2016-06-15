//
//  LessonListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonListCell.h"

@implementation LessonListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lessonName = [[UILabel alloc] init];
        [self.contentView addSubview:self.lessonName];
        self.lessonName.font = FONT15;
        self.lessonName.textAlignment = NSTextAlignmentLeft;
        [self.lessonName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(18);
            make.right.equalTo(self.contentView).with.offset(120);
        }];
        
        self.lessonTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.lessonTime];
        self.lessonTime.font = FONT12;
        self.lessonTime.text = @"00:00";
        [self.lessonTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 14));
        }];
    }
    return self;
}
@end
