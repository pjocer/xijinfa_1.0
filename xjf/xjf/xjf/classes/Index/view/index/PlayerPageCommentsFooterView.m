//
//  PlayerPageCommentsFooterView.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageCommentsFooterView.h"

@implementation PlayerPageCommentsFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lookCommentsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.lookCommentsButton];
        self.lookCommentsButton.backgroundColor = [UIColor whiteColor];
        [self.lookCommentsButton setTitle:@"查看所有评论" forState:UIControlStateNormal];
        [self.lookCommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(1);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-2);
        }];
    }
    return self;
}

@end
