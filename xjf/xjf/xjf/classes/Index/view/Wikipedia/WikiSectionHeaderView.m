//
//  WikiSectionHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiSectionHeaderView.h"

@implementation WikiSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                self.bounds.size.height - 1)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        //
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWITH, 35)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"推荐";
        _titleLabel.font = FONT15;
        [self addSubview:_titleLabel];
        //
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWITH - 110, 0, 100, 35)];
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.textColor = [UIColor xjfStringToColor:@"#0061b0"];
        _moreLabel.font = FONT12;
        _moreLabel.text = @"更多";
        [self addSubview:_moreLabel];
    }
    return self;
}


@end
