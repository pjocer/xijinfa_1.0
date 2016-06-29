//
//  CommentListCell.m
//  xjf
//
//  Created by PerryJ on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentListCell.h"
#import <UIImageView+WebCache.h>
#import "XJAccountManager.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import "StringUtil.h"
#import "TaViewController.h"

@interface CommentListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *invest_category;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *avatar_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClicked:)];
    [_avatar addGestureRecognizer:avatar_tap];
}

- (void)avatarClicked:(UITapGestureRecognizer *)gesture {
    if (![self.data.user.id isEqualToString:[[XJAccountManager defaultManager] user_id]]) {
        UIViewController *controller = getCurrentDisplayController();
        TaViewController *ta = [[TaViewController alloc] init];
        ta.nav_title = [NSString stringWithFormat:@"%@的主页", self.data.user.nickname];
        ta.model = self.data.user;
        [controller.navigationController pushViewController:ta animated:YES];
    }
}

- (void)setData:(TopicDataModel *)data {
    _data = data;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:data.user.avatar]];
    _nickname.text = data.user.nickname;
    _invest_category.text = data.user.quote;
    _time.text = [StringUtil compareCurrentTime:data.created_at];
    _content.text = data.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
