//
//  WikiMoreClassificationCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiMoreClassificationCell.h"

@implementation WikiMoreClassificationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.font = FONT12;
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.layer.cornerRadius = 15;
        self.titleLabel.layer.borderColor = [UIColor xjfStringToColor:@"#c7c7cc"].CGColor;
        self.titleLabel.layer.borderWidth = 1;
        self.titleLabel.text = @"xxxx";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}

- (void)setModel:(WikiPediaCategoriesDataModel *)model
{
    if (model) {
        _model = model;
    }
    self.titleLabel.text = model.name;
}

@end
