//
//  CommentCell.m
//  xjf
//
//  Created by PerryJ on 16/6/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "StringUtil.h"

@interface CommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *commentFor;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(TopicDataModel *)model {
    _model = model;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar]];
    _nickname.text = _model.user.nickname;
    _summary.text = _model.user.summary;
    _content.text = _model.content;
    _commentFor.text = _model.topic_content;
    _time.text = [StringUtil compareCurrentTime:_model.created_at];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
