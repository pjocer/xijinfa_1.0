//
//  XJFEmploymentInformationCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFEmploymentInformationCollectionViewCell.h"
#import "StringUtil.h"

@interface XJFEmploymentInformationCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *viedoDetail;

@end

@implementation XJFEmploymentInformationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}

- (void)setModel:(TalkGridModel *)model
{
    if (model) {
        _model = model;
    }
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.videoTitle.text = model.title;
    self.viedoDetail.text = [NSString filterHTML:model.content];
    self.Date.text = [StringUtil compareCurrentTime:model.updated_at];
}

@end
