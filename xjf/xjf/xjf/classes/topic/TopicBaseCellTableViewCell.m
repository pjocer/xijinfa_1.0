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
#import "XjfRequest.h"
#import "XJAccountManager.h"
#import "ZToastManager.h"
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
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
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
    if ([[XJAccountManager defaultManager] accessToken]) {
        
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }
}
- (void)praise_Clicked:(UITapGestureRecognizer *)gesture {
    if ([[XJAccountManager defaultManager] accessToken]) {
        [[ZToastManager ShardInstance] showprogress];
        if (!_praiseImageView.isHighlighted) {
            XjfRequest *request = [[XjfRequest alloc] initWithAPIName:praise RequestMethod:POST];
            request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"topic",@"id":self.model.id}];
            [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"errCode"] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSInteger count = [_praiseLabel.text integerValue];
                        _praiseLabel.text = [NSString stringWithFormat:@"%ld",count+1];
                        _praiseImageView.highlighted = !_praiseImageView.isHighlighted;
                    });
                }else {
                    [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
                }
                [[ZToastManager ShardInstance] hideprogress];
            } failedBlock:^(NSError * _Nullable error) {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
                [[ZToastManager ShardInstance] hideprogress];
            }];
        }else {
            XjfRequest *request = [[XjfRequest alloc] initWithAPIName:praise RequestMethod:DELETE];
            request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"topic",@"id":self.model.id}];
            [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"errCode"] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSInteger count = [_praiseLabel.text integerValue];
                        _praiseLabel.text = [NSString stringWithFormat:@"%ld",count-1];
                        _praiseImageView.highlighted = !_praiseImageView.isHighlighted;
                    });
                }else {
                    [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
                }
                [[ZToastManager ShardInstance] hideprogress];
            } failedBlock:^(NSError * _Nullable error) {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
                [[ZToastManager ShardInstance] hideprogress];
            }];
        }
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }

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
    _praiseImageView.highlighted = model.is_like;
    if (![model.type isEqualToString:@"qa"]) {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#FFA53C"];
        _extension.text = @"讨论";
    }else {
        _extension.backgroundColor = [UIColor xjfStringToColor:@"#3FA9F5"];
        _extension.text = @"问答";
    }
    [self heightByModel:model];
}

- (CGFloat)heightByModel:(TopicDataModel *)model {
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-20 fontsize:15];
    CGFloat height = 10+40+10+contentHeight;
    if (model.categories.count > 0) {
        if (self.contentView.subviews.count == 11) {
            float length = 10;
            for (int i = 0; i < model.categories.count; i++) {
                TopicCategoryLabel *label = model.categories[i];
                NSString *buttonTitle = [NSString stringWithFormat:@"#%@#",label.name];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                [button setTitleColor:[UIColor xjfStringToColor:@"#0061B0"] forState:UIControlStateNormal];
                button.titleLabel.font = FONT12;
                button.tag = 350+i;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                CGRect frame = [StringUtil calculateLabelRect:buttonTitle height:14 fontSize:12];
                CGFloat width = frame.size.width;
                if (length+10+width <= SCREENWITH) {
                    button.frame = CGRectMake(length, contentHeight+70, width, 14);
                    self.cellHeight = height + 34 + 36;
                }else {
                    length = 10;
                    button.frame = CGRectMake(length, contentHeight+94, width, 14);
                    self.cellHeight = height + 30 + 28 + 36;
                }
                [self.contentView addSubview:button];
                length = 10*(i+1)+width+length;
            }
        }
    }else {
        if (self.contentView.subviews.count != 11) {
            for (UIView *view in self.contentView.subviews) {
                if (view.tag>=350) {
                    [view removeFromSuperview];
                }
            }
        }
        self.cellHeight = height+10+36;
    }
    return self.cellHeight;
}

- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld",button.tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
