//
//  UserLoadCell.m
//  xjf
//
//  Created by PerryJ on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserLoadCell.h"

@interface UserLoadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *user_icon;
@property (weak, nonatomic) IBOutlet UIImageView *vip_tie;
@property (weak, nonatomic) IBOutlet UILabel *vip_level;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *vip_mark;
@property (weak, nonatomic) IBOutlet UILabel *user_gold;
@property (weak, nonatomic) IBOutlet UILabel *user_fans;
@property (weak, nonatomic) IBOutlet UILabel *user_attention;

@end

@implementation UserLoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vip_level.text = @"";
    self.user_icon.layer.cornerRadius = 75/2.0;
    self.user_icon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UserProfileModel *)model {
    NSLog(@"%@",model);
    self.username.text = model.result.nickname;
    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:model.result.avatar] placeholderImage:[UIImage imageNamed:@"user_unload"]];
    self.user_gold.text = model.result.coin_balance;
    self.user_fans.text = model.result.followings;
    self.user_attention.text = model.result.followers;
}

@end
