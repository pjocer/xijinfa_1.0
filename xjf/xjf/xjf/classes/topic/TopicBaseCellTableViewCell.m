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
#import "NewCommentViewController.h"
#import "TaViewController.h"
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
        ta.nav_title = [NSString stringWithFormat:@"%@的主页",self.model.user.nickname];
        ta.model = self.model.user;
        [controller.navigationController pushViewController:ta animated:YES];
    }
}
- (void)commentClicked:(UITapGestureRecognizer *)gesture {
    if ([[XJAccountManager defaultManager] accessToken]) {
        NewCommentViewController *controler = [[NewCommentViewController alloc] init];
        controler.topic_id = self.model.id;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controler];
        UIViewController *vc = getCurrentDisplayController();
        [vc.navigationController presentViewController:nav animated:YES completion:nil];
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
    _identity.text = model.user.summary;
    _update_at.text = [StringUtil compareCurrentTime:model.updated_at];
    _content.text = model.content;
    _commentLabel.text = model.replies_count;
    _praiseLabel.text = model.likes_count;
    _praiseImageView.highlighted = model.user_liked;
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
    if (model.taxonomy_tags.count > 0) {
        if (self.contentView.subviews.count == 11) {
            [self addSubviewsWithModel:model];
        }else {
            [self removeSubviews];
            [self addSubviewsWithModel:model];
        }
    }else {
        self.cellHeight = height+10+36;
        if (self.contentView.subviews.count != 11) {
            [self removeSubviews];
        }
    }
    return self.cellHeight;
}

- (void)removeSubviews{
    for (UIView *view in self.contentView.subviews) {
        if (view.tag>=350) {
            [view removeFromSuperview];
        }
    }
}

-(void)addSubviewsWithModel:(TopicDataModel *)model {
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-20 fontsize:15];
    CGFloat height = 10+40+10+contentHeight;
    CGFloat all = 0;
    CGFloat alll = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat tap = 10;
    NSMutableArray *labels = [NSMutableArray array];
    for (CategoryLabel *label in model.taxonomy_tags) {
        [labels addObject:label.title];
    }
    for (int i = 0; i < labels.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"#%@#",labels[i]];
        CGSize size = [title sizeWithFont:FONT12 constrainedToSize:CGSizeMake(SCREENWITH, 14) lineBreakMode:1];
        all = all + tap + size.width;
        if (all <= SCREENWITH) {
            x = all - size.width;
            y = contentHeight+70;
            button.frame = CGRectMake(x, y, size.width, 14);
            self.cellHeight = height + 34 + 36;
        }else if (all <= SCREENWITH*2 && all>SCREENWITH) {
            alll = alll + tap + size.width;
            if (alll <= SCREENWITH) {
                x = alll - size.width;
                y = contentHeight+94;
                button.frame = CGRectMake(x, y, size.width, 14);
                self.cellHeight = height + 30 + 28 + 36;
            }else {
                continue;
            }
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xjfStringToColor:@"#0061B0"] forState:UIControlStateNormal];
        button.titleLabel.font = FONT12;
        button.tag = 350+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}

- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld",button.tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
