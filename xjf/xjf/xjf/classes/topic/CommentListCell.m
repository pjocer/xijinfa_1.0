//
//  CommentListCell.m
//  xjf
//
//  Created by PerryJ on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentListCell.h"
#import <UIImageView+WebCache.h>
@interface CommentListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *invest_category;
@property (weak, nonatomic) IBOutlet UILabel *like_count;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setData:(CommentData *)data {
    _data = data;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:data.user.avatar]];
    _nickname.text = data.user.nickname;
    _invest_category.text = data.user.invest_category;
    _time.text = data.created_at;
    _like_count.text = data.like_count;
    _content.text = data.content;
}
- (IBAction)likeClicked:(UIButton *)sender {
    sender.selected =  !sender.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
