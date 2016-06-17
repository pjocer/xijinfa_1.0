//
//  PlayerPageRecommendedHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageRecommendedHeaderView.h"
#import "IndexSectionView.h"

@interface PlayerPageRecommendedHeaderView ()
@property (nonatomic, strong) IndexSectionView *indexSectionView;
@end

@implementation PlayerPageRecommendedHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indexSectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                self.bounds.size.height - 1)];
        [self addSubview:self.indexSectionView];
        self.indexSectionView.moreLabel.text = @"";
        self.indexSectionView.titleLabel.text = @"推荐";
    }
    return self;
}

@end
