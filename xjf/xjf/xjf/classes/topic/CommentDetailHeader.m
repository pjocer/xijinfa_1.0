//
//  CommentDetailHeader.m
//  xjf
//
//  Created by PerryJ on 16/5/31.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentDetailHeader.h"
#import <UIImageView+WebCache.h>
#import "StringUtil.h"
#import "XJAccountManager.h"
#import "TaViewController.h"

@interface CommentDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *invest_category;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation CommentDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *avatar_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClicked:)];
    [_avatar addGestureRecognizer:avatar_tap];
}

- (void)avatarClicked:(UITapGestureRecognizer *)gesture {
    if (![[[XJAccountManager defaultManager] user_id] isEqualToString:self.model.user.id]) {
        UIViewController *controller = getCurrentDisplayController();
        TaViewController *ta = [[TaViewController alloc] init];
        ta.nav_title = [NSString stringWithFormat:@"%@的主页", self.model.user.nickname];
        ta.model = self.model.user;
        [controller.navigationController pushViewController:ta animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TopicDataModel *)model {
    _model = model;
    _content.text = model.content;
    _nickname.text = model.user.nickname;
    _invest_category.text = model.user.quote;
    _time.text = [StringUtil compareCurrentTime:model.created_at];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]];
}

- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld", (long)button.tag);
}
@end
