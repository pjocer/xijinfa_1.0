//
//  PlayerPageDescribeHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeHeaderView.h"

@interface PlayerPageDescribeHeaderView ()
@property (nonatomic, strong) UILabel *thumbUpLabel;
@end


@implementation PlayerPageDescribeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.thumbUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.thumbUpButton];
        [self.thumbUpButton                                                setImage:[[UIImage imageNamed:@"iconLike"]
                                                                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.thumbUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        self.thumbUpLabel = [[UILabel alloc] init];
        [self addSubview:self.thumbUpLabel];
        self.thumbUpLabel.font = FONT12;
        self.thumbUpLabel.textColor = AssistColor;
        [self.thumbUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbUpButton);
            make.left.equalTo(self.thumbUpButton.mas_right);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];

        self.collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.collectionButton];
        [self.collectionButton                                             setImage:[[UIImage imageNamed:@"iconFavorites"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.shareButton];
        [self.shareButton                                                  setImage:[[UIImage imageNamed:@"iconShare"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.equalTo(self.collectionButton.mas_left).with.offset(-10);
            make.size.mas_equalTo(self.collectionButton);
        }];
    }
    return self;
}

- (void)setAllControl
{
    
}

- (void)setModel:(LessonDetailListResultModel *)model {
    if (model) {
        _model = model;
    }
    
    self.thumbUpLabel.text = model.like_count;
    if (model.user_liked) {
        [self.thumbUpButton setImage:[[UIImage imageNamed:@"iconLikeOn"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [self.thumbUpButton setImage:[[UIImage imageNamed:@"iconLike"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    if (model.user_favored) {
        [_collectionButton setImage:[[UIImage imageNamed:@"iconFavoritesOn"]
                                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [_collectionButton setImage:[[UIImage imageNamed:@"iconFavorites"]
                                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

@end
