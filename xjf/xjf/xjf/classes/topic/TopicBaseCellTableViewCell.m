//
//  TopicBaseCellTableViewCell.m
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicBaseCellTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "StringUtil.h"
@interface TopicBaseCellTableViewCell () 
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UILabel *extension;
@property (weak, nonatomic) IBOutlet UILabel *update_at;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *segment_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_constrain;
@property (weak, nonatomic) IBOutlet UIView *comment;
@property (weak, nonatomic) IBOutlet UIView *praise;
@property (weak, nonatomic) IBOutlet UIButton *category_1st;
@property (weak, nonatomic) IBOutlet UIButton *category_2nd;
@property (weak, nonatomic) IBOutlet UIButton *category_3rd;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@end

@implementation TopicBaseCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = 20;
    self.avatar.layer.masksToBounds = YES;
    self.extension.layer.cornerRadius = 5;
    self.extension.layer.masksToBounds = YES;
    _left_constrain.constant = SCREENWITH/4-18.5;
    _right_constrain.constant = SCREENWITH/4-18.5;
    UITapGestureRecognizer *comment_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentClicked:)];
    [_comment addGestureRecognizer:comment_tap];
    UITapGestureRecognizer *praise_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praise_Clicked:)];
    [_praise addGestureRecognizer:praise_tap];
    // Initialization code
}
- (void)commentClicked:(UITapGestureRecognizer *)gesture {
    
}
- (void)praise_Clicked:(UITapGestureRecognizer *)gesture {

}
-(void)setModel:(TopicDataModel *)model {
    _model = model;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]];
    _nickname.text = model.user.nickname;
    _identity.text = @"";
    _update_at.text = model.user.updated_at;
    _content.text = model.content;
    _commentLabel.text = model.reply_count;
    _praiseLabel.text = model.like_count;
    if (![model.type isEqualToString:@"QA"]) {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#FFA53C"];
        _extension.text = @"讨论";
    }else {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#3FA9F5"];
        _extension.text = @"问答";
    }
    if (model.categories.count > 0) {
        for (int i = 0; i < model.categories.count; i++) {
            CategoryLabel *label = model.categories[i];
            if (i == 0) {
                [_category_1st setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else if (i == 1) {
                [_category_2nd setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else if (i == 2) {
                [_category_3rd setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else {
                NSLog(@"好多Label");
            }
        }
        if (model.categories.count == 1) {
            _category_2nd.hidden = YES;
            _category_3rd.hidden = YES;
            _category_1st.hidden = NO;
        }else if (model.categories.count == 2) {
            _category_3rd.hidden = YES;
            _category_1st.hidden = NO;
            _category_2nd.hidden = NO;
        }else if (model.categories.count == 3) {
            _category_1st.hidden = NO;
            _category_2nd.hidden = NO;
            _category_3rd.hidden = NO;
        }
    }else {
        _category_3rd.hidden = YES;
        _category_2nd.hidden = YES;
        _category_1st.hidden = YES;
    }
}

-(void)setDetail:(TopicDetailModel *)detail {
    _detail = detail;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_detail.result.user.avatar]];
    _nickname.text = _detail.result.user.nickname;
    _identity.text = @"";
    _update_at.text = _detail.result.user.updated_at;
    _content.text = _detail.result.content;
    _commentLabel.text = _detail.result.reply_count;
    _praiseLabel.text = _detail.result.like_count;
    if (![_detail.result.type isEqualToString:@"QA"]) {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#FFA53C"];
        _extension.text = @"讨论";
    }else {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#3FA9F5"];
        _extension.text = @"问答";
    }
    if (_detail.result.categories.count > 0) {
        for (int i = 0; i < _detail.result.categories.count; i++) {
            TopicCategoryLabel *label = _detail.result.categories[i];
            if (i == 0) {
                [_category_1st setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else if (i == 1) {
                [_category_2nd setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else if (i == 2) {
                [_category_3rd setTitle:[NSString stringWithFormat:@"#%@#",label.name] forState:UIControlStateNormal];
            }else {
                NSLog(@"好多Label");
            }
        }
        if (_detail.result.categories.count == 1) {
            _category_2nd.hidden = YES;
            _category_3rd.hidden = YES;
            _category_1st.hidden = NO;
        }else if (_detail.result.categories.count == 2) {
            _category_3rd.hidden = YES;
            _category_1st.hidden = NO;
            _category_2nd.hidden = NO;
        }else if (_detail.result.categories.count == 3) {
            _category_1st.hidden = NO;
            _category_2nd.hidden = NO;
            _category_3rd.hidden = NO;
        }
    }else {
        _category_3rd.hidden = YES;
        _category_2nd.hidden = YES;
        _category_1st.hidden = YES;
    }
}

- (IBAction)category_1stAction:(UIButton *)sender {
}
- (IBAction)category_2ndAction:(UIButton *)sender {
}
- (IBAction)category_3rdAction:(UIButton *)sender {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
