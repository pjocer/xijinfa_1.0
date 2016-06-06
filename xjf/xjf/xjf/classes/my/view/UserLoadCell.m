//
//  UserLoadCell.m
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserLoadCell.h"
#import "XJAccountManager.h"
#import "Fans_FocusViewController.h"

@interface UserLoadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *user_icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *vip_mark;
@property (weak, nonatomic) IBOutlet UILabel *user_gold;
@property (weak, nonatomic) IBOutlet UILabel *user_fans;
@property (weak, nonatomic) IBOutlet UILabel *user_attention;
@property (weak, nonatomic) IBOutlet UILabel *segment_lie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segment_line_height;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *focus;

@end

@implementation UserLoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.user_icon.layer.cornerRadius = 75/2.0;
    self.user_icon.layer.masksToBounds = YES;
    self.segment_line_height.constant = 0.3f;
    
    UITapGestureRecognizer *fans = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansAction:)];
    [_user_fans addGestureRecognizer:fans];
    [_fans addGestureRecognizer:fans];
    UITapGestureRecognizer *focus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAction:)];
    [_user_attention addGestureRecognizer:focus];
    [_focus addGestureRecognizer:focus];
}

- (void)fansAction:(UITapGestureRecognizer *)tap {
    UIViewController *controller = getCurrentDisplayController();
    Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:self.model.result.id type:0 nickname:self.model.result.nickname];
    [controller.navigationController pushViewController:fans_focus animated:YES];
}
- (void)focusAction:(UITapGestureRecognizer *)tap {
    UIViewController *controller = getCurrentDisplayController();
    Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:self.model.result.id type:1 nickname:self.model.result.nickname];
    [controller.navigationController pushViewController:fans_focus animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(UserProfileModel *)model {
    _model = model;
    self.username.text = model.result.nickname;
    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:model.result.avatar] placeholderImage:[UIImage imageNamed:@"user_unload"]];
    self.user_gold.text = model.result.coin_balance?:@"0";
    self.user_fans.text = model.result.followers?:@"0";
    self.user_attention.text = model.result.followings?:@"0";
    _vip_mark.hidden = model.result.membership==nil?YES:NO;
}

@end
