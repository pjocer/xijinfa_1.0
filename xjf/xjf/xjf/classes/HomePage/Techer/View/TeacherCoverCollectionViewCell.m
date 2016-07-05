//
//  TeacherCoverCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherCoverCollectionViewCell.h"

@implementation TeacherCoverCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}

- (void)setModel:(TeacherDetailResult *)model {
    if (model) {
        _model = model;
    }
    if (model.cover.count > 0) {
        for (TeacherDetailCover *cover in model.cover) {
            if ([cover.size isEqualToString:@"default"]) {
              [self.techerCover sd_setImageWithURL:[NSURL URLWithString:cover.url]];
            }
        }
    }
    
    self.techerDescribe.text = model.subtitle;
    
        if (model.user_favored) {
            [self.focus setTitle:@"已关注" forState:UIControlStateNormal];
            self.focus.backgroundColor = BackgroundColor;
            [self.focus setTintColor:[UIColor grayColor]];
        }else {
            [self.focus setTitle:@"关注" forState:UIControlStateNormal];
            self.focus.backgroundColor = BlueColor;
            [self.focus setTintColor:[UIColor whiteColor]];
        }
}

@end
