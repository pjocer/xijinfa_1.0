//
//  IndexSectionView.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexSectionView.h"
#import "xjfConfigure.h"
@interface IndexSectionView()
{
    
    
}

@property (nonatomic, strong) UILabel *moreLabel;

@end
@implementation IndexSectionView
@synthesize titleLabel=_titleLabel;
@synthesize moreLabel=_moreLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor blackColor];
        //
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 30)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        //
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWITH-110, 0, 100, 30)];
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.backgroundColor = [UIColor clearColor];
        _moreLabel.textColor = [UIColor whiteColor];
        _moreLabel.font = [UIFont systemFontOfSize:12];
        _moreLabel.text=@"更多 >";
        [self addSubview:_moreLabel];
    }
    return self;
}
- (void) dealloc
{
    self.titleLabel=nil;
    self.moreLabel=nil;
}
@end
