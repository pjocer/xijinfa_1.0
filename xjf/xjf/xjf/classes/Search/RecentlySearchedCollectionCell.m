//
//  RecentlySearchedCollectionCell.m
//  xjf
//
//  Created by PerryJ on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RecentlySearchedCollectionCell.h"

@interface RecentlySearchedCollectionCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation RecentlySearchedCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderColor = [NormalColor CGColor];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}
- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}
@end
