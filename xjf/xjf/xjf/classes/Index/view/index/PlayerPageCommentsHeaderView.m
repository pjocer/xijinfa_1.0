//
//  PlayerPageCommentsHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageCommentsHeaderView.h"
#import "IndexSectionView.h"
#import "XJAccountManager.h"

@interface PlayerPageCommentsHeaderView ()

@property(nonatomic, strong) UIView *backGroundView;

@property(nonatomic, strong) IndexSectionView *indexSectionView;
///用户头像
@property(nonatomic, strong) UIImageView *userImage;

@end

@implementation PlayerPageCommentsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //indexSectionView
        self.indexSectionView = [[IndexSectionView alloc] init];
        [self addSubview:self.indexSectionView];
        self.indexSectionView.moreLabel.text = @"";
        self.indexSectionView.titleLabel.text = @"评论";
        [self.indexSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.right.equalTo(self);
            make.height.mas_offset(35);
        }];

        // backGroundView
        self.backGroundView = [[UIView alloc] init];
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.indexSectionView.mas_bottom).with.offset(1);
            make.bottom.equalTo(self).with.offset(-1);
        }];

        //userImage
        self.userImage = [[UIImageView alloc] init];
        self.userImage.backgroundColor = BackgroundColor
        self.userImage.layer.masksToBounds = YES;
        self.userImage.layer.cornerRadius = 20;
        [self addSubview:self.userImage];
        [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backGroundView);
            make.left.equalTo(self).with.offset(10);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        if ([[XJAccountManager defaultManager] accessToken] != nil ||
                [[XJAccountManager defaultManager] accessToken].length > 0) {
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:
                    [XJAccountManager defaultManager].user_model.result.avatar]];
        } else {
            self.userImage.image = [UIImage imageNamed:@"user_unload"];
        }

        //commentsButton
        self.commentsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.commentsButton];
        [self.commentsButton setTitle:@"有什么感想快来说说吧" forState:UIControlStateNormal];
        self.commentsButton.backgroundColor = BackgroundColor;
        self.commentsButton.titleLabel.font = FONT15;
        [self.commentsButton setTintColor:[UIColor xjfStringToColor:@"#9a9a9a"]];
        self.commentsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.commentsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.commentsButton.layer.masksToBounds = YES;
        self.commentsButton.layer.cornerRadius = 5;
        [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userImage);
            make.left.equalTo(self.userImage.mas_right).with.offset(10);
            make.right.equalTo(self).with.offset(-20);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

@end
