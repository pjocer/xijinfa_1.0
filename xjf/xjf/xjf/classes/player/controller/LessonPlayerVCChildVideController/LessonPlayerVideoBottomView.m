//
//  LessonPlayerVideoBottomView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerVideoBottomView.h"

@implementation LessonPlayerVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        
        //collection
        self.collection = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.collection];
        self.collection.tintColor = [UIColor xjfStringToColor:@"#greyishBrown"];
        [self.collection setImage:[UIImage imageNamed:@"user_faovrite"] forState:UIControlStateNormal];
        [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        //download
        self.download = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.download];
        self.download.tintColor = [UIColor xjfStringToColor:@"#greyishBrown"];
         [self.download setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self.download mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.collection.mas_left).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        //collectionLogo
        self.collectionLogo = [[UIImageView alloc] init];
        [self addSubview:self.collectionLogo];
        self.collectionLogo.tintColor = [UIColor xjfStringToColor:@"#warmGrey"];
        self.collectionLogo.image = [UIImage imageNamed:@"share_logo"];
        [self.collectionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        //
        self.collectionCount = [[UILabel alloc] init];
        [self addSubview:self.collectionCount];
        self.collectionCount.textColor = AssistColor;
        self.collectionCount.font = FONT12;
        self.collectionCount.text = @"xxxxxx";
        self.collectionCount.textAlignment = NSTextAlignmentLeft;
        [self.collectionCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectionLogo.mas_right).with.offset(5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 14));
        }];
        
    }
    return self;
}

@end
