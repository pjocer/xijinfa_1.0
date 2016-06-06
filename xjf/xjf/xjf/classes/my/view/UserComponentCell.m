//
//  UserComponentCell.m
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserComponentCell.h"
#import "UzysGridView.h"
#import "XJMarket.h"

@interface UserComponent : UzysGridViewCell
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *goodsCount;
@end

@implementation UserComponent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_icon];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_titleLabel];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.font = FONT12;

        self.goodsCount = [[UILabel alloc] initWithFrame:CGRectZero];
        self.goodsCount.backgroundColor = [UIColor redColor];
        self.goodsCount.layer.masksToBounds = YES;
        self.goodsCount.layer.cornerRadius = 11.f;
        self.goodsCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.goodsCount];
        self.goodsCount.hidden = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _icon.image = image;
    [self bringSubviewToFront:_icon];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    [self bringSubviewToFront:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x_icon = self.frame.size.width / 2.0;
    CGFloat y_icon = self.frame.size.height / 2.0 - 17.5f;
    CGPoint center_icon = CGPointMake(x_icon, y_icon);
    _icon.frame = CGRectMake(0, 0, 25, 25);
    _icon.center = center_icon;

    CGFloat x_titleLabel = self.frame.size.width / 2.0;
    CGFloat y_titleLabel = self.frame.size.height / 2.0 + 17.5f;
    CGPoint center_titleLabel = CGPointMake(x_titleLabel, y_titleLabel);
    _titleLabel.frame = CGRectMake(0, 0, 80, 13);
    _titleLabel.center = center_titleLabel;

    self.goodsCount.frame = CGRectMake(0, 0, 22, 22);
}
@end

@interface UserComponentCell () <UzysGridViewDelegate, UzysGridViewDataSource, UzysGridViewCellDelegate>
@property(nonatomic, strong) NSMutableArray *images;
@property(nonatomic, strong) NSMutableArray *titles;
@end

@implementation UserComponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UzysGridView *gridView = [[UzysGridView alloc]
                initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
                     numOfRow:3
                 numOfColumns:4
                   cellMargin:1.0f];
        gridView.delegate = self;
        gridView.dataSource = self;
        [self addSubview:gridView];
    }
    return self;
}

- (NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview {
    return 12;
}

- (UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    UserComponent *component = [[UserComponent alloc] initWithFrame:CGRectNull];
    if (index < self.titles.count) {
        UIImage *image = [UIImage imageNamed:self.images[index]];
        component.image = image;
        component.title = self.titles[index];
    }
    return component;
}

- (void)gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(componentDidSelected:)]) {
        [self.delegate componentDidSelected:index];
    }
}

- (NSMutableArray *)images {
    if (_images == nil || !_images) {
        _images = [NSMutableArray array];
        NSArray *image = @[
                @"user_lesson", @"user_teacher", @"user_topic", @"user_answer",
                @"user_history", @"user_faovrite", @"user_purse", @"user_cart",
                @"user_check", @"user_feedback"];
        [_images addObjectsFromArray:image];
    }
    return _images;
}

- (NSMutableArray *)titles {
    if (_titles == nil || !_titles) {
        _titles = [NSMutableArray array];
        NSArray *title = @[
                @"我的课程", @"我的老师", @"我的话题", @"我的回答",
                @"播放记录", @"我的收藏", @"我的钱包", @"购物车",
                @"每日签到", @"反馈意见"];
        [_titles addObjectsFromArray:title];
    }
    return _titles;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if ([component.title isEqualToString:@"购物车"]) {
//        
//        if ([[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] count] != 0) {
//            component.goodsCount.hidden = NO;
//            component.goodsCount.text = [NSString stringWithFormat:@"%ld",[[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] count]];
//        }
//    }
}

@end
