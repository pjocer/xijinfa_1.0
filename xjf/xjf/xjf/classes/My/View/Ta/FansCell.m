//
//  FansCell.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = 55 / 2.0;
    self.avatar.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTeacherModel:(TeacherListData *)teacherModel
{
    if (teacherModel) {
        _teacherModel = teacherModel;
    }
    self.nickname.text = teacherModel.title;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:teacherModel.guru_avatar]];
    self.summary.text = teacherModel.subtitle;
}


@end
