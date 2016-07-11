//
//  TeacherLisetTeacherCoverCell.m
//  xjf
//
//  Created by Hunter_wang on 16/7/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherLisetTeacherCoverCell.h"

@interface TeacherLisetTeacherCoverCell ()
@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;

@property (weak, nonatomic) IBOutlet UILabel *teacherDetail;
@end

@implementation TeacherLisetTeacherCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
}



- (void)setModel:(TeacherListData *)model {
    if (model) {
        _model = model;
    }
    
    for (TalkGridCover *cover in model.cover) {
        if ([cover.size isEqualToString:@"default"]) {
            [self.teacherImage sd_setImageWithURL:[NSURL URLWithString:cover.url]];
        }
    }

    self.teacherName.text = model.title;
    self.teacherDetail.text = model.subtitle;
}

@end
