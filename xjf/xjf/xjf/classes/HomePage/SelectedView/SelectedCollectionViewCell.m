//
//  SelectedCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/7/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedCollectionViewCell.h"

@implementation SelectedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        ViewRadius(self.contentView, 5);
        ViewBorder(self.contentView, [UIColor xjfStringToColor:@"#efefef"], 1.0);
        
        self.title = [[UILabel alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.title];
        self.title.font = FONT12;
        self.title.textColor = [UIColor xjfStringToColor:@"#9b9b9b"];
        self.title.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setDataStr:(NSString *)dataStr
{
    if (dataStr) {
        _dataStr = dataStr;
    }
    self.title.text = _dataStr;
    self.title.frame = CGRectMake(0, 0, [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.contentView.frame.size.height)].width, self.contentView.frame.size.height);
}


@end
