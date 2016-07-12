//
//  SearchRecommendCell.m
//  xjf
//
//  Created by PerryJ on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchRecommendCell.h"

@interface SearchRecommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLine;
@property id a;
@end

@implementation SearchRecommendCell

- (void)setModel:(TalkGridModel *)model {
    _model = model;
    if (model.cover && _model.cover.count > 0) {
        TalkGridCover *tempCover = model.cover.firstObject;
        [_avatar sd_setImageWithURL:[NSURL URLWithString:tempCover.url]];
    }
    _className.text = _model.title;
    _teacher.text = [NSString stringWithFormat:@"主讲: Mr.Ji"];
    _period.text = [NSString stringWithFormat:@"10000000节课爽不爽？"];
    _nowPrice.text = model.price;
    _oldPrice.text = [model.original_price isEqualToString:@""] ? @"0" : model.original_price;
    _priceLine.text = _oldPrice.text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _priceLine.frame = CGRectMake(0, 0, _oldPrice.frame.size.width, 1);
    _priceLine.center = _oldPrice.center;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
