//
//  SearchSectionTwo.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchSectionTwo.h"
#import <UIImageView+WebCache.h>

@interface SearchSectionTwo ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLine;

@end

@implementation SearchSectionTwo

- (void)setModel:(TalkGridModel *)model {
    _model = model;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    _className.text = model.title;
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
