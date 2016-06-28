//
//  XJFWikipediaCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFWikipediaCollectionViewCell.h"

@interface XJFWikipediaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@end

@implementation XJFWikipediaCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}

- (void)setModel:(TalkGridModel *)model {
    if (model) {
        _model = model;
    }
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.title.text = model.title;
    self.playCount.text = [NSString stringWithFormat:@"%@ 人看过", model.view];
}


@end
