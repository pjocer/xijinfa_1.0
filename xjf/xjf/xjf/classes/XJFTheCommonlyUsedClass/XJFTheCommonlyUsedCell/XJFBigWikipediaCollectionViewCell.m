//
//  XJFBigWikipediaCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBigWikipediaCollectionViewCell.h"

@interface XJFBigWikipediaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *playCount;

@end

@implementation XJFBigWikipediaCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
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
    self.playCount.text = [NSString stringWithFormat:@"%@ 人看过", model.view_count];
}


@end
