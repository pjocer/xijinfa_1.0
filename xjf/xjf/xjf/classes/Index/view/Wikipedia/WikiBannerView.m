//
//  WikiBannerView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiBannerView.h"

@implementation WikiBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        NSArray *arr2 = @[@"http://www.5068.com/u/faceimg/20140725173411.jpg", @"http://file27.mafengwo.net/M00/52/F2/wKgB6lO_PTyAKKPBACID2dURuk410.jpeg", @"http://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg"];
//        _carouselView = [[XRCarouselView alloc] initWithFrame:self.bounds imageArray:arr2];
        self.backgroundColor = [UIColor whiteColor];
        _carouselView = [[XRCarouselView alloc] initWithFrame:self.bounds];
        _carouselView.changeMode = ChangeModeFade;
        _carouselView.pagePosition = PositionBottomCenter;
        [self addSubview:_carouselView];
    }
    return self;
}

@end
