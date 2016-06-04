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
    UITapGestureRecognizer *avatar_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClicked:)];
    [_avatar addGestureRecognizer:avatar_tap];
    _comment_category.layer.cornerRadius = 5;
    _comment_category.layer.masksToBounds = YES;
    // Initialization code
}

- (void)avatarClicked:(UITapGestureRecognizer *)gesture {
    UIViewController *controller = getCurrentDisplayController();
    TaViewController *ta = [[TaViewController alloc] init];
    ta.nav_title = [NSString stringWithFormat:@"%@的主页",self.model.result.user.nickname];
    ta.model = self.model.result.user;
    [controller.navigationController pushViewController:ta animated:YES];
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
    _time.text = [StringUtil compareCurrentTime:model.result.created_at];
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
        if (self.contentView.subviews.count == 7) {
            CGFloat all = 0;
            CGFloat alll = 0;
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat tap = 10;
            NSMutableArray *labels = [NSMutableArray array];
            for (TopicCategoryLabel *label in model.result.categories) {
                [labels addObject:label.name];
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
                    self.cellHeight = height + 44;
                }else if (all <= SCREENWITH*2 && all>SCREENWITH) {
                    alll = alll + tap + size.width;
                    if (alll <= SCREENWITH) {
                        x = alll - size.width;
                        y = contentHeight+94;
                        button.frame = CGRectMake(x, y, size.width, 14);
                        self.cellHeight = height + 68;
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
    }else {
        if (self.contentView.subviews.count != 7) {
            for (UIView *view in self.contentView.subviews) {
                if (view.tag>=400) {
                    [view removeFromSuperview];
                }
            }
        }
        self.cellHeight = height+10+10;
    }
}
- (void)buttonClicked:(UIButton *)button {
    NSLog(@"%ld",button.tag);
}
@end
