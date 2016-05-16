//
//  PlayerPageDescribeCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeCell.h"

@implementation PlayerPageDescribeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.videoDescribe = [[UILabel alloc] init];
        [self addSubview:self.videoDescribe];
        self.videoDescribe.font = FONT12;
        self.videoDescribe.textColor = AssistColor;
        self.videoDescribe.text = @"xxxxxxxxx";
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.videoDescribe.frame = CGRectMake(10, 0, self.bounds.size.width - 40, 20);
}


@end
