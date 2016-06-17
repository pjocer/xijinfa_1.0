//
//  TaBaseCellFoot.m
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TaBaseCellFoot.h"
#import "XJAccountManager.h"
#import "TaTopicViewController.h"
#import "UserInfoModel.h"
#import "MyCommentViewController.h"

@interface TaBaseCellFoot ()
@property (weak, nonatomic) IBOutlet UILabel *topic;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@end

@implementation TaBaseCellFoot

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *comment_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentClicked:)];
    [_comment addGestureRecognizer:comment_tap];
    UITapGestureRecognizer *topic_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicClicked:)];
    [_topic addGestureRecognizer:topic_tap];
}

- (void)commentClicked:(UIGestureRecognizer *)gesture {
    MyCommentViewController *controller = [[MyCommentViewController alloc] initWith:(UserInfoModel *) self.model];
    UIViewController *vc = getCurrentDisplayController();
    [vc.navigationController pushViewController:controller animated:YES];
}

- (void)setModel:(JSONModel *)model {
    UserInfoModel *userInfo = (UserInfoModel *) model;
    _model = userInfo;
    _topic.text = [NSString stringWithFormat:@"%@的话题", userInfo.nickname];
    _comment.text = [NSString stringWithFormat:@"%@的回答", userInfo.nickname];
}

- (void)topicClicked:(UIGestureRecognizer *)gesture {
    UserInfoModel *user_info = (UserInfoModel *) self.model;
    UIViewController *controller = getCurrentDisplayController();
    TaTopicViewController *ta_topic = [[TaTopicViewController alloc] initWithID:user_info.id nickname:user_info.nickname];
    [controller.navigationController pushViewController:ta_topic animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
