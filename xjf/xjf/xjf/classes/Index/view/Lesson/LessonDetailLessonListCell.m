//
//  LessonDetailLessonListCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonDetailLessonListCell.h"
#import "XJMarket.h"

@interface LessonDetailLessonListCell ()
@property (nonatomic, strong) UIView *backGroundView;
@end

@implementation LessonDetailLessonListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backGroundView = [[UIView alloc] init];
        [self.contentView addSubview:_backGroundView];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        ViewRadius(_backGroundView, 5);

//        iconFavorites
        self.favorites = [[UIImageView alloc] init];
        [_backGroundView addSubview:self.favorites];
        [self.favorites mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backGroundView).with.offset(10);
            make.centerY.equalTo(_backGroundView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        self.title = [[UILabel alloc] init];
        [_backGroundView addSubview:self.title];
        self.title.font = FONT15;
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backGroundView).with.offset(34);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(18);
            make.width.equalTo(_backGroundView).multipliedBy(0.5).with.offset(-25);
        }];
        self.title.text = @"股票基础课程 第x课";

        self.lessonPrice = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backGroundView addSubview:self.lessonPrice];
        self.lessonPrice.titleLabel.font = FONT12;
        [self.lessonPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backGroundView).with.offset(-10);
            make.centerY.equalTo(_backGroundView);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(80);
        }];
        [self.lessonPrice setTintColor:[UIColor whiteColor]];
        ViewRadius(self.lessonPrice, 12.5);
        [self.lessonPrice addTarget:self action:@selector(pushOrderDetailPage:) forControlEvents:UIControlEventTouchUpInside];
        
        //shop
        self.shop = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.shop];
        [self.shop setImage:[[UIImage imageNamed:@"LessonOneShop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        ViewRadius(self.shop, 12.5);
        [self.shop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lessonPrice);
            make.right.equalTo(self.lessonPrice.mas_left).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.shop addTarget:self action:@selector(shop:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)pushOrderDetailPage:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(lessonDetailLessonListCell:PriceButtonPushOrderDetail:)]) {
        [_delegate lessonDetailLessonListCell:self PriceButtonPushOrderDetail:_talkGridModel];
    }
}

- (void)shop:(UIButton *)sender
{
    [[XJMarket sharedMarket] addShoppingCardByModel:_talkGridModel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setTalkGridModel:(TalkGridModel *)talkGridModel {
    if (talkGridModel) {
        _talkGridModel = talkGridModel;
    }
    self.title.text = talkGridModel.title;
   
    //是否买过此节
    if (_talkGridModel.user_subscribed == YES || _talkGridModel.user_purchased == YES) {
        [self.lessonPrice setTitle:@"已购买" forState:UIControlStateNormal];
        self.lessonPrice.backgroundColor = [UIColor xjfStringToColor:@"#3c98e8"];
        self.shop.hidden = YES;
    }else{
        [self.lessonPrice setTitle:[NSString stringWithFormat:@"单节 ￥%.2lf",_talkGridModel.price.floatValue / 100] forState:UIControlStateNormal];
        self.lessonPrice.backgroundColor = [UIColor xjfStringToColor:@"#ea5f5f"];
        self.shop.hidden = NO;
    }
    
   
}


@end
