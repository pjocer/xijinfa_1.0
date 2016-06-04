//
//  TaBaseCellFoot.m
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TaBaseCellFoot.h"

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
    NSLog(@"comment");
}
- (void)topicClicked:(UIGestureRecognizer *)gesture {
    NSLog(@"topic");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
