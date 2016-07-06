//
//  XJFSchoolCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFSchoolCollectionViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface XJFSchoolCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UIButton *teacherCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@end

@implementation XJFSchoolCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
    ViewRadius(self.teacherCoverImg, 15.0);
}

- (void)setModel:(TalkGridModel *)model {
    if (model) {
        _model = model;
    }
    if (model.cover && model.cover.count > 0) {
        TalkGridCover *tempCover = model.cover.firstObject;
        [self.videoImg sd_setImageWithURL:[NSURL URLWithString:tempCover.url]];
    }
    
    self.title.text = model.title;
    self.describe.text = [NSString stringWithFormat:@"%@ 人看过",model.view_count];
//    if (_model.taxonomy_gurus.count != 0 && _model.taxonomy_gurus) {
//        taxonomy_gurus *gurus = model.taxonomy_gurus.firstObject;
//        [self.teacherCoverImg sd_setBackgroundImageWithURL:[NSURL URLWithString:gurus.guru_avatar] forState:UIControlStateNormal];
//    }
}

@end
