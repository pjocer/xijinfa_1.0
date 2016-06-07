//
//  EmployedbannerHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedbannerHeaderView.h"

@implementation EmployedbannerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _carouselView = [[XRCarouselView alloc] initWithFrame:self.bounds];

        _carouselView.pagePosition = PositionBottomCenter;
        [self addSubview:_carouselView];
    }
    return self;
}
@end
