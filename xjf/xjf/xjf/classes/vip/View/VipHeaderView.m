//
//  VipHeaderView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VipHeaderView.h"
#import "XJAccountManager.h"
#import <ReactiveCocoa/NSNotificationCenter+RACSupport.h>
#import "UserProfileModel.h"

@interface VipHeaderView ()
@property (nonatomic, strong) UserProfileModel *userProfileModel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *prompt;
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIView *vipProgressBackGroudView;
@property (nonatomic, strong) UIView *vipProgress;
@property (nonatomic, strong) UILabel *levelLeftLabel;
@property (nonatomic, strong) UILabel *levelRightLabel;
@property (nonatomic, strong) UILabel *levelCenterLabel;
@property (nonatomic, strong) UIImageView *levelCenterImg;
@property (nonatomic, strong) UILabel *vipTitle;
@property (nonatomic, strong) UILabel *vipEndDate;
@property (nonatomic, strong) UIImageView *vipCrown;
@end

@implementation VipHeaderView
static CGFloat bottomViewH = 70;
static CGFloat promptH = 14;
static CGFloat userImageWAndH = 75;
static CGFloat levelLabelWAndH = 48;
static CGFloat pandding = 10;
static CGFloat userNameH = 18;
static CGFloat vipProgressBackGroudViewH = 15;
static CGFloat vipProgressBackGroudViewTop = 42;
static CGFloat levelCenterImgH = 24;
static CGFloat payVipW = 90;
static CGFloat payVipH = 33;
static CGFloat vipTitleW = 100;
static CGFloat vipTitleH = 14;
static CGFloat vipCrownW = 21;
static CGFloat vipCrownH = 18;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColorByTopColor:[UIColor xjfStringToColor:@"#fae675"]
                               BottomColor:[UIColor xjfStringToColor:@"#ffa800"]];
        //bottomView
        self.bottomView = [[UIView alloc] init];
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(bottomViewH);
        }];
        self.bottomView.alpha = 0.3;
        self.bottomView.backgroundColor = [UIColor xjfStringToColor:@"#66000000"];

        //prompt
        self.prompt = [[UILabel alloc] init];
        [self addSubview:self.prompt];
        [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self.bottomView);
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width / 2, promptH));
        }];
        self.prompt.textColor = [UIColor whiteColor];
        self.prompt.textAlignment = NSTextAlignmentLeft;
        self.prompt.text = @"登录后查看更多精彩";
        self.prompt.font = FONT12;

        //vipProgressBackGroudView
        self.vipProgressBackGroudView = [[UIView alloc] init];
        [self addSubview:self.vipProgressBackGroudView];
        self.vipProgressBackGroudView.backgroundColor = [UIColor whiteColor];
        [self.vipProgressBackGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(vipProgressBackGroudViewTop);
            make.height.mas_equalTo(vipProgressBackGroudViewH);
        }];

        //vipProgress
        //vipProgressBackGroudView
        self.vipProgress = [[UIView alloc] init];
        [self addSubview:self.vipProgress];
        self.vipProgress.backgroundColor = [UIColor redColor];
        [self.vipProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).with.offset(vipProgressBackGroudViewTop);
            make.height.mas_equalTo(vipProgressBackGroudViewH);
            make.width.mas_equalTo(self.vipProgressBackGroudView).multipliedBy(0.75);
        }];

        //userImg
        self.userImg = [[UIImageView alloc] init];
        [self addSubview:self.userImg];
        [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(pandding + 5);
            make.size.mas_equalTo(CGSizeMake(userImageWAndH, userImageWAndH));
        }];
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = userImageWAndH / 2;
        self.userImg.image = [UIImage imageNamed:@"user_unload"];

        //userName
        self.userName = [[UILabel alloc] init];
        [self addSubview:self.userName];
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.userImg);
            make.top.equalTo(self.userImg.mas_bottom).with.offset(pandding + 5);
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width / 2, userNameH));
        }];
        self.userName.textColor = [UIColor whiteColor];
        self.userName.textAlignment = NSTextAlignmentCenter;
        self.userName.text = @"登录/注册";
        self.userName.font = FONT15;

        //login
        self.login = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.login];
        [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.userImg);
            make.bottom.equalTo(self.userName);
        }];

        //levelLeftLabel
        self.levelLeftLabel = [[UILabel alloc] init];
        [self addSubview:self.levelLeftLabel];
        [self.levelLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self.vipProgressBackGroudView);
            make.size.mas_equalTo(CGSizeMake(levelLabelWAndH, levelLabelWAndH));
        }];
        self.levelLeftLabel.layer.masksToBounds = YES;
        self.levelLeftLabel.layer.cornerRadius = levelLabelWAndH / 2;
        self.levelLeftLabel.textColor = [UIColor redColor];
        self.levelLeftLabel.backgroundColor = [UIColor whiteColor];
        self.levelLeftLabel.textAlignment = NSTextAlignmentCenter;
        self.levelLeftLabel.font = FONT15;

        //levelRightLabel
        self.levelRightLabel = [[UILabel alloc] init];
        [self addSubview:self.levelRightLabel];
        [self.levelRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self.vipProgressBackGroudView);
            make.size.mas_equalTo(CGSizeMake(levelLabelWAndH, levelLabelWAndH));
        }];
        self.levelRightLabel.layer.masksToBounds = YES;
        self.levelRightLabel.layer.cornerRadius = levelLabelWAndH / 2;
        self.levelRightLabel.textColor = [UIColor redColor];
        self.levelRightLabel.backgroundColor = [UIColor whiteColor];
        self.levelRightLabel.textAlignment = NSTextAlignmentCenter;
        self.levelRightLabel.font = FONT15;

        //levelCenterImg
        self.levelCenterImg = [[UIImageView alloc] init];
        [self addSubview:self.levelCenterImg];
        self.levelCenterImg.image = [UIImage imageNamed:@"levelCenterImg"];
        [self.levelCenterImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userImg.mas_bottom);
            make.left.right.equalTo(self.userImg);
            make.height.mas_equalTo(levelCenterImgH);
        }];

        //levelCenterLabel
        self.levelCenterLabel = [[UILabel alloc] init];
        [self addSubview:self.levelCenterLabel];
        [self.levelCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.levelCenterImg);
            make.height.mas_equalTo(self.levelCenterImg);
            make.width.mas_equalTo(self.levelCenterImg).multipliedBy(0.65);
        }];
        self.levelCenterLabel.textColor = [UIColor whiteColor];
        self.levelCenterLabel.textAlignment = NSTextAlignmentCenter;
        self.levelCenterLabel.font = FONT15;

        //payVip
        self.payVip = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.payVip];
        [self.payVip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-pandding);
            make.centerY.equalTo(self.bottomView);
            make.size.mas_equalTo(CGSizeMake(payVipW, payVipH));
        }];
        self.payVip.backgroundColor = [UIColor redColor];
        self.payVip.tintColor = [UIColor whiteColor];
        self.payVip.layer.masksToBounds = YES;
        self.payVip.layer.cornerRadius = 4;
        self.payVip.titleLabel.font = FONT15;

        //vipTitle
        self.vipTitle = [[UILabel alloc] init];
        [self addSubview:self.vipTitle];
        [self.vipTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payVip);
            make.left.equalTo(self).with.offset(pandding);
            make.size.mas_equalTo(CGSizeMake(vipTitleW, vipTitleH));
        }];
        self.vipTitle.textColor = [UIColor whiteColor];
        self.vipTitle.textAlignment = NSTextAlignmentLeft;
        self.vipTitle.font = FONT12;

        //vipCrown
        self.vipCrown = [[UIImageView alloc] init];
        [self addSubview:self.vipCrown];
        [self.vipCrown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vipTitle);
            make.left.equalTo(self.vipTitle.mas_right).with.offset(pandding);
            make.size.mas_equalTo(CGSizeMake(vipCrownW, vipCrownH));
        }];

        //vipEndDate
        self.vipEndDate = [[UILabel alloc] init];
        [self addSubview:self.vipEndDate];
        [self.vipEndDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vipTitle.mas_bottom).with.offset(7);
            make.left.equalTo(self).with.offset(pandding);
            make.height.mas_equalTo(vipCrownH);
            make.right.equalTo(self.payVip.mas_left).with.offset(-10);
        }];
        self.vipEndDate.textColor = [UIColor whiteColor];
        self.vipEndDate.textAlignment = NSTextAlignmentLeft;
        self.vipEndDate.font = FONT12;
        self.userProfileModel = [[UserProfileModel alloc]
                initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
        [self setUserInfo];
        @weakify(self)
        ReceivedNotification(self, UserInfoDidChangedNotification, ^(NSNotification *notification) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userProfileModel = notification.object;
                [self setUserInfo];
            });
        });

    }
    return self;
}

- (void)setUserInfo {
    //用户未登录
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        self.userImg.image = [UIImage imageNamed:@"user_unload"];
        self.prompt.text = @"登录后查看更多精彩";
        self.userName.text = @"登录/注册";
        self.vipProgressBackGroudView.hidden = YES;
        self.vipProgress.hidden = YES;
        self.levelCenterImg.hidden = YES;
        self.levelLeftLabel.hidden = YES;
        self.levelCenterLabel.hidden = YES;
        self.levelRightLabel.hidden = YES;
        self.payVip.hidden = YES;
    }
        //用户已经登录
    else {
        [self.userImg sd_setImageWithURL:[NSURL URLWithString:self.userProfileModel.result.avatar]];
        self.prompt.text = @"普通用户";
        self.userName.text = self.userProfileModel.result.nickname;
        self.vipProgressBackGroudView.hidden = NO;
        self.vipProgress.hidden = NO;
        self.levelCenterImg.hidden = NO;
        self.levelLeftLabel.hidden = NO;
        self.levelCenterLabel.hidden = NO;
        self.levelRightLabel.hidden = NO;
        self.payVip.hidden = NO;
        self.levelLeftLabel.text =
                [NSString stringWithFormat:@"Lv.%@", self.userProfileModel.result.level];
        self.levelCenterLabel.text =
                [NSString stringWithFormat:@"Lv.%d", self.userProfileModel.result.level.intValue + 1];
        self.levelRightLabel.text =
                [NSString stringWithFormat:@"Lv.%d", self.userProfileModel.result.level.intValue + 2];
        //是否是会员
        if (self.userProfileModel.result.membership.count != 0) {
            [self.payVip setTitle:@"续费会员" forState:UIControlStateNormal];
            UserMembership *model = self.userProfileModel.result.membership.firstObject;
            self.vipTitle.text = model.title;
            self.vipEndDate.text = [NSString stringWithFormat:@"%@到期", model.end_time];
            self.vipCrown.image = [UIImage imageNamed:@"vip_tie"];
            self.prompt.hidden = YES;
            self.vipTitle.hidden = NO;
            self.vipEndDate.hidden = NO;
            self.vipCrown.hidden = NO;

        } else {
            [self.payVip setTitle:@"开通会员" forState:UIControlStateNormal];
            self.prompt.hidden = NO;
            self.vipTitle.hidden = YES;
            self.vipEndDate.hidden = YES;
            self.vipCrown.hidden = YES;
        }
    }
}

@end
