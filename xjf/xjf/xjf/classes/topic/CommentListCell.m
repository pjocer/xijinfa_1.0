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
@interface CommentListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *invest_category;
@property (weak, nonatomic) IBOutlet UILabel *like_count;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *like_image;

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
    _time.text = [StringUtil compareCurrentTime:data.created_at];
    _like_count.text = data.like_count;
    _content.text = data.content;
    _like_image.selected = data.user_liked;
}
- (IBAction)likeClicked:(UIButton *)sender {
    if ([[XJAccountManager defaultManager] accessToken]) {
        [[ZToastManager ShardInstance] showprogress];
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:praise RequestMethod:sender.selected?DELETE:POST];
        request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"reply",@"id":self.data.id}];
        [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves  error:nil];
            if ([dic[@"errCode"] integerValue] == 0) {
                [[ZToastManager ShardInstance] hideprogress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    sender.selected = !sender.isSelected;
                    _like_count.text = [NSString stringWithFormat:@"%ld",sender.isSelected?_like_count.text.integerValue+1:_like_count.text.integerValue-1];
                });
            }else {
                [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
            }
        } failedBlock:^(NSError * _Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络请求失败"];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
