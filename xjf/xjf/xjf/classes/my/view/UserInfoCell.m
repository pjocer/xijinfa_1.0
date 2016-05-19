//
//  UserInfoCell.m
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *user_icon;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *user_introduce;

@end

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.user_icon.layer.cornerRadius = 75/2.0;
    self.user_icon.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(UserProfileModel *)model {
    self.nickname.text = model.result.nickname;
    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:model.result.avatar] placeholderImage:[UIImage imageNamed:@"user_unload"]];
    self.user_introduce.text = @"一句话介绍你自己（兴趣或职业）";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
