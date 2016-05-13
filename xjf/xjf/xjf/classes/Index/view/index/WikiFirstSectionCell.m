//
//  WikiFirstSectionCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiFirstSectionCell.h"

@implementation WikiFirstSectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc] init];
        self.label.font = FONT15;
        self.label.text = @"XXX";
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
//        self.label.backgroundColor = [UIColor redColor];
        self.label.layer.borderColor = [UIColor xjfStringToColor:@"#c7c7cc"].CGColor;
        self.label.layer.borderWidth = 1;
        self.label.layer.masksToBounds = YES;
        self.label.layer.cornerRadius = 12;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(8);
        make.left.equalTo(self.contentView).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.right.equalTo(self.contentView).with.offset(-8);
        
    }];
}

@end
