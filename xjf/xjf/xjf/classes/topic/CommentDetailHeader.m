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
@interface CommentDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *invest_category;
@property (weak, nonatomic) IBOutlet UILabel *comment_category;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end

@implementation CommentDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellHeight = 0;
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    _comment_category.layer.cornerRadius = 5;
    _comment_category.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(TopicDetailModel *)model {
    _model = model;
    _content.text = model.result.content;
    _nickname.text = model.result.user.nickname;
    _invest_category.text = model.result.user.invest_category;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.result.user.avatar]];
    if (![model.result.type isEqualToString:@"QA"]) {
        _comment_category.backgroundColor = [UIColor xjfStringToColor:@"#FFA53C"];
        _comment_category.text = @"讨论";
    }else {
        _comment_category.backgroundColor = [UIColor xjfStringToColor:@"#3FA9F5"];
        _comment_category.text = @"问答";
    }
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.result.content width:SCREENWITH-20 fontsize:15];
    CGFloat height = 10+40+10+contentHeight;
    if (model.result.categories.count > 0) {
        float length = 10;
        for (int i = 0; i < model.result.categories.count; i++) {
            TopicCategoryLabel *label = model.result.categories[i];
            NSString *buttonTitle = [NSString stringWithFormat:@"#%@#",label.name];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor xjfStringToColor:@"#0061B0"] forState:UIControlStateNormal];
            button.titleLabel.font = FONT12;
            button.tag = 400+i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = [StringUtil calculateLabelRect:buttonTitle height:14 fontSize:12];
            CGFloat width = frame.size.width;
            if (length+10+width <= SCREENWITH) {
                button.frame = CGRectMake(length, contentHeight+70, width, 14);
                self.cellHeight = height + 34 + 10;
            }else {
                length = 10;
                button.frame = CGRectMake(length, contentHeight+94, width, 14);
                self.cellHeight = height + 30 + 28 + 10;
            }
            [self.contentView addSubview:button];
            [self.contentView setNeedsLayout];
            [self.contentView layoutIfNeeded];
            length = 10*(i+1)+width+length;
        }
    }else {
        self.cellHeight = height+10+10;
    }
}
- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld",button.tag);
}
@end
