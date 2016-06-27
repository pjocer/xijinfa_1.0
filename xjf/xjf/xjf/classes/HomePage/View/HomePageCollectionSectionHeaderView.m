//
//  HomePageCollectionSectionHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageCollectionSectionHeaderView.h"

@implementation HomePageCollectionSectionHeaderView
static CGFloat Pandding = 10;
static CGFloat SectionTitleW = 60;
static CGFloat SectionTitleH = 18;
static CGFloat SectionMoreW = 24;
static CGFloat SectionMoreH = 14;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.sectionTitle = [[UILabel alloc] init];
        [self addSubview:self.sectionTitle];
        self.sectionTitle.font = FONT15;
        
        self.SectionMore = [[UILabel alloc] init];
        [self addSubview:self.SectionMore];
        self.SectionMore.font = FONT12;
        self.SectionMore.textColor = AssistColor;
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints
{
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(Pandding);
        make.bottom.equalTo(self).with.offset(-Pandding);
        make.size.mas_equalTo(CGSizeMake(SectionTitleW, SectionTitleH));
    }];
    
    [self.SectionMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sectionTitle);
        make.left.equalTo(self.sectionTitle.mas_right).with.offset(Pandding / 2);
        make.size.mas_equalTo(CGSizeMake(SectionMoreW, SectionMoreH));
    }];
}

@end
