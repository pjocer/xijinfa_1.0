//
//  XJFTeacherCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFTeacherCollectionViewCell.h"

@interface XJFTeacherCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *teacherDetail;

@end

@implementation XJFTeacherCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}

- (void)setModel:(TeacherListData *)model {
    if (model) {
        _model = model;
    }
    [self.teacherImage sd_setImageWithURL:[NSURL URLWithString:model.guru_avatar]];
    self.teacherName.text = model.title;
    self.teacherDetail.text = model.subtitle;
}

@end
