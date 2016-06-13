//
//  LessonPlayerVideoBottomView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerVideoBottomView.h"

@implementation LessonPlayerVideoBottomView
static NSInteger collectionTag = 101;
static NSInteger downloadTag = 102;
static NSInteger collectionLogoTag = 103;

- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        
        //collection
        self.collection = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.collection];
        self.collection.tintColor = [UIColor xjfStringToColor:@"#greyishBrown"];
        [self.collection setImage:[UIImage imageNamed:@"iconFavorites"] forState:UIControlStateNormal];
        [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [self.collection addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.collection.tag = collectionTag;
        
        //share
        self.download = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.download];
        self.download.tintColor = [UIColor xjfStringToColor:@"#greyishBrown"];
        [self.download setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self.download mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.collection.mas_left).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [self.download addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.download.tag = downloadTag;
        
        //collectionLogo
        self.collectionLogo = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.collectionLogo];
        [self.collectionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        [self.collectionLogo addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionLogo.tag = collectionLogoTag;
        
        //
        self.collectionCount = [[UILabel alloc] init];
        [self addSubview:self.collectionCount];
        self.collectionCount.textColor = AssistColor;
        self.collectionCount.font = FONT12;
        self.collectionCount.textAlignment = NSTextAlignmentLeft;
        [self.collectionCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectionLogo.mas_right).with.offset(5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 14));
        }];
        
    }
    return self;
}

- (void)click:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LessonPlayerVideoBottomView:DidDownloadOrCollectionButton:)]) {
      [self.delegate LessonPlayerVideoBottomView:self DidDownloadOrCollectionButton:sender];
    } 
}

- (void)setModel:(TalkGridModel *)model
{
    if (model) {
        _model = model;
    }
    if (model.user_favored) {
        [self.collection setImage:[[UIImage imageNamed:@"iconFavoritesOn"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [self.collection setImage:[UIImage imageNamed:@"iconFavorites"] forState:UIControlStateNormal];
    }

}

@end
