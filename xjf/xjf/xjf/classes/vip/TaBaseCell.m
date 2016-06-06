//
//  TaBaseCell.m
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TaBaseCell.h"
#import "UserInfoModel.h"
#import <UIImageView+WebCache.h>
#import "XJAccountManager.h"
#import "Fans_FocusViewController.h"
@interface TaBaseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *vip_tie;
@property (weak, nonatomic) IBOutlet UILabel *fans_count;
@property (weak, nonatomic) IBOutlet UILabel *focus_count;
@property (weak, nonatomic) IBOutlet UILabel *qianming;
@property (weak, nonatomic) IBOutlet UIView *fans_background;
@property (weak, nonatomic) IBOutlet UIView *focus_background;
@property (weak, nonatomic) IBOutlet UILabel *taFans;
@property (weak, nonatomic) IBOutlet UILabel *taFocus;
@end

@implementation TaBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 75/2;
    _avatar.layer.masksToBounds = YES;
}
-(void)setModel:(JSONModel *)model {
    UserInfoModel *userinfo = (UserInfoModel *)model;
    _model = userinfo;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:userinfo.avatar]];
    _nickname.text = userinfo.nickname;
    _vip_tie.hidden = userinfo.membership==nil?YES:NO;
    _fans_count.text = userinfo.follower?:@"0";
    _focus_count.text = userinfo.following?:@"0";
    _taFans.text = [NSString stringWithFormat:@"%@的粉丝",userinfo.nickname];
    _taFocus.text = [NSString stringWithFormat:@"%@关注的人",userinfo.nickname];
    UITapGestureRecognizer *fans_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansClicked:)];
    [_fans_background addGestureRecognizer:fans_tap];
    UITapGestureRecognizer *following_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followClicked:)];
    [_focus_background addGestureRecognizer:following_tap];
}
- (void)fansClicked:(UITapGestureRecognizer *)gesture {
    UserInfoModel *userinfo = (UserInfoModel *)self.model;
    UIViewController *controller = getCurrentDisplayController();
    Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:userinfo.id type:0 nickname:userinfo.nickname];
    [controller.navigationController pushViewController:fans_focus animated:YES];
}
- (void)followClicked:(UITapGestureRecognizer *)gesture{
    UserInfoModel *userinfo = (UserInfoModel *)self.model;
    UIViewController *controller = getCurrentDisplayController();
    Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:userinfo.id type:1 nickname:userinfo.nickname];
    [controller.navigationController pushViewController:fans_focus animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
