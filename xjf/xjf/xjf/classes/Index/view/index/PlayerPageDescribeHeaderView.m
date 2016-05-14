//
//  PlayerPageDescribeHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeHeaderView.h"

@interface PlayerPageDescribeHeaderView ()

@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIView *bottomBackGroundView;

@end


@implementation PlayerPageDescribeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //TOP control
        self.topBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        [self addSubview:self.topBackGroundView];
        self.topBackGroundView.backgroundColor = [UIColor whiteColor];
        
        self.collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.collectionButton];
        self.collectionButton.backgroundColor = [UIColor redColor];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topBackGroundView);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.shareButton];
        self.shareButton.backgroundColor = [UIColor redColor];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topBackGroundView);
            make.right.equalTo(self.collectionButton.mas_left).with.offset(-10);
            make.size.mas_equalTo(self.collectionButton);
        }];
        
        self.downLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.downLoadButton];
        self.downLoadButton.backgroundColor = [UIColor redColor];
        [self.downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topBackGroundView);
            make.right.equalTo(self.shareButton.mas_left).with.offset(-10);
            make.size.mas_equalTo(self.collectionButton);
        }];
        
        //Bottom control
        self.bottomBackGroundView = [[UIView alloc] init];
        self.bottomBackGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomBackGroundView];
        [self.bottomBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBackGroundView.mas_bottom).with.offset(10);
            make.left.right.and.bottom.equalTo(self);
        }];
        
        self.title = [[UILabel alloc] init];
        [self addSubview:self.title];
        self.title.font = FONT15;
        self.title.text = @"XXXXXX";
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.bottomBackGroundView).with.offset(10);
            make.right.equalTo(self).with.offset(-80);
            make.height.mas_equalTo(15);
        }];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.rightButton];
        self.rightButton.backgroundColor = [UIColor redColor];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        self.titleDetail = [[UILabel alloc] init];
        [self addSubview:self.titleDetail];
        self.titleDetail.font = FONT12;
        self.titleDetail.textColor = AssistColor;
        self.titleDetail.text = @"播放: xxx次  类型: xx";
        [self.titleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.title);
            make.size.mas_equalTo(self.title);
        }];
        
    }
    
    
    
    return self;
}

@end
