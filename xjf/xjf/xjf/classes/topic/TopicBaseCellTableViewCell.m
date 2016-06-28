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
#import "NewComment_Topic.h"
#import "TaViewController.h"

@interface TopicBaseCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UILabel *update_at;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_constrain;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *comment;
@property (weak, nonatomic) IBOutlet UIView *praise;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
@end

@implementation TopicBaseCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _left_width.constant = (SCREENWITH-20)/2.0;
    _right_width.constant = (SCREENWITH-20)/2.0-1;
    _left_constrain.constant = (SCREENWITH-20)/2.0/2.0-17.5;
    _right_constrain.constant = ((SCREENWITH-20)/2.0-1.0)/2.0-17.5;
    UITapGestureRecognizer *avatar_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClicked:)];
    [_avatar addGestureRecognizer:avatar_tap];
    UITapGestureRecognizer *comment_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentClicked:)];
    [_comment addGestureRecognizer:comment_tap];
    UITapGestureRecognizer *praise_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praise_Clicked:)];
    [_praise addGestureRecognizer:praise_tap];
}

- (void)avatarClicked:(UITapGestureRecognizer *)gesture {
    if (![[[XJAccountManager defaultManager] user_id] isEqualToString:self.model.user_id]) {
        UIViewController *controller = getCurrentDisplayController();
        TaViewController *ta = [[TaViewController alloc] init];
        ta.nav_title = [NSString stringWithFormat:@"%@的主页", self.model.user.nickname];
        ta.model = self.model.user;
        [controller.navigationController pushViewController:ta animated:YES];
    }
}

- (void)commentClicked:(UITapGestureRecognizer *)gesture {
    if ([[XJAccountManager defaultManager] accessToken]) {
        NewComment_Topic *controler = [[NewComment_Topic alloc] initWithType:NewComment];
        controler.topic_id = self.model.id;
        controler.type = self.model.type;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controler];
        UIViewController *vc = getCurrentDisplayController();
        [vc.navigationController presentViewController:nav animated:YES completion:nil];
    } else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }
}

- (void)praise_Clicked:(UITapGestureRecognizer *)gesture {
    if ([[XJAccountManager defaultManager] accessToken]) {
        [[ZToastManager ShardInstance] showprogress];
        if (!_praiseImageView.isHighlighted) {
            XjfRequest *request = [[XjfRequest alloc] initWithAPIName:praise RequestMethod:POST];
            request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"topic", @"id" : self.model.id}];
            [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"errCode"] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSInteger count = [_praiseLabel.text integerValue];
                        _praiseLabel.text = [NSString stringWithFormat:@"%ld", (long)(count + 1)];
                        _praiseImageView.highlighted = !_praiseImageView.isHighlighted;
                    });
                } else {
                    [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
                }
                [[ZToastManager ShardInstance] hideprogress];
            }                  failedBlock:^(NSError *_Nullable error) {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
                [[ZToastManager ShardInstance] hideprogress];
            }];
        } else {
            XjfRequest *request = [[XjfRequest alloc] initWithAPIName:praise RequestMethod:DELETE];
            request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"topic", @"id" : self.model.id}];
            [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"errCode"] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSInteger count = [_praiseLabel.text integerValue];
                        _praiseLabel.text = [NSString stringWithFormat:@"%ld", (long)(count - 1)];
                        _praiseImageView.highlighted = !_praiseImageView.isHighlighted;
                    });
                } else {
                    [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
                }
                [[ZToastManager ShardInstance] hideprogress];
            }                  failedBlock:^(NSError *_Nullable error) {
                [[ZToastManager ShardInstance] showtoast:@"网络异常"];
                [[ZToastManager ShardInstance] hideprogress];
            }];
        }
    } else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }

}

- (void)setModel:(TopicDataModel *)model {
    _model = model;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]];
    _nickname.text = model.user.nickname;
    _identity.text = model.user.quote;
    _update_at.text = [StringUtil compareCurrentTime:model.updated_at];
    _content.text = model.content;
    _commentLabel.text = model.replies_count;
    _praiseLabel.text = model.likes_count;
    _praiseImageView.highlighted = model.user_liked;
}

- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld", (long)button.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
