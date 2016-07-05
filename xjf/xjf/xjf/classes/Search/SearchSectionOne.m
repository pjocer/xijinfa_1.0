//
//  SearchSectionOne.m
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchSectionOne.h"
#import "XJMarket.h"
#import "XJFCacheHandler.h"
@implementation SearchSectionOne

- (void)initSubViews {
    for (UIButton *button in self.contentView.subviews) {
        if (button) {
            [button removeFromSuperview];
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat all = 0;
    CGFloat alll = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat tap = 10;
    NSArray *results = [[XJFCacheHandler sharedInstance] recentlySearched];
    for (int i = 0; i < results.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [[UIColor xjfStringToColor:@"#9a9a9a"] CGColor];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 33 / 2.0;
        button.layer.masksToBounds = YES;
        NSString *title = [NSString stringWithFormat:@"%@", results[i]];
        CGSize size = [title sizeWithFont:FONT15 constrainedToSize:CGSizeMake(SCREENWITH, 33) lineBreakMode:1];
        all = all + tap + size.width + 20;
        if (all <= SCREENWITH) {
            x = all - size.width - 20;
            y = 10;
            button.frame = CGRectMake(x, y, size.width + 20, 33);
            self.cellHeight = 15 + 39;
        } else if (all <= SCREENWITH * 2 && all > SCREENWITH) {
            alll = alll + tap + size.width + 20;
            if (alll <= SCREENWITH) {
                x = alll - size.width - 20;
                y = 53;
                button.frame = CGRectMake(x, y, size.width + 20, 33);
                self.cellHeight = 15 + 67;
            } else {
                return;
            }
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
        button.titleLabel.font = FONT12;
        button.tag = 180 + i;
        [button addTarget:self action:@selector(resultClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    if (results.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 14)];
        label.font = FONT12;
        label.text = @"暂无搜索记录";
        label.textColor = NormalColor;
        [self.contentView addSubview:label];
        self.cellHeight = 35;
    }
}

- (void)resultClicked:(UIButton *)button {
    NSArray *results = [[XJFCacheHandler sharedInstance] recentlySearched];
    if (self.SearchHandler) self.SearchHandler([results objectAtIndex:button.tag - 180]);
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
