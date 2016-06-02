//
//  IndexSectionView.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexSectionView.h"
#import "xjfConfigure.h"


@implementation IndexSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        //
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWITH, 35)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = FONT15;
        _titleLabel.textColor = NormalColor;
        [self addSubview:_titleLabel];
        //
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWITH-110, 0, 100, 35)];
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.textColor = [UIColor xjfStringToColor:@"#0061b0"];
        _moreLabel.font = FONT12;
        _moreLabel.text=@"更多";
        [self addSubview:_moreLabel];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
        self.bottomView.backgroundColor = BackgroundColor;
        [self addSubview:self.bottomView];
        self.bottomView.hidden = YES;
        
        
    }
    return self;
}
- (void) dealloc
{
    self.titleLabel=nil;
    self.moreLabel=nil;
}
@end
