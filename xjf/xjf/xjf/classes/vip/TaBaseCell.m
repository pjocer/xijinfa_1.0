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
@interface TaBaseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *vip_tie;
@property (weak, nonatomic) IBOutlet UILabel *fans_count;
@property (weak, nonatomic) IBOutlet UILabel *focus_count;
@property (weak, nonatomic) IBOutlet UILabel *qianming;
@property (weak, nonatomic) IBOutlet UIView *fans_background;
@property (weak, nonatomic) IBOutlet UIView *focus_background;
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
    _vip_tie.hidden = userinfo.membership?NO:YES;
    _fans_count.text = userinfo.follower?:@"0";
    _focus_count.text = userinfo.following?:@"0";
    UITapGestureRecognizer *fans_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansClicked:)];
    [_fans_background addGestureRecognizer:fans_tap];
    UITapGestureRecognizer *following_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followClicked:)];
    [_focus_background addGestureRecognizer:following_tap];
}
- (void)fansClicked:(UITapGestureRecognizer *)gesture {
    NSLog(@"粉丝");
}
- (void)followClicked:(UITapGestureRecognizer *)gesture{
    NSLog(@"关注");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
