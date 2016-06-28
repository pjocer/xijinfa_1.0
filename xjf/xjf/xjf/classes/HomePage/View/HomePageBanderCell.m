//
//  HomePageBanderCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageBanderCell.h"

@implementation HomePageBanderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 10, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 10) imageArray:nil];
        [self.contentView addSubview:_carouselView];
        _carouselView.changeMode = ChangeModeFade;
        ViewRadius(_carouselView, 5.0);
        
    }
    return self;
}

@end
