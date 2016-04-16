//
//  UserCheckInCell.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserCheckInCell.h"

@interface UserCheckInCell()
{
    
}
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UIButton *checkBtn;
@end
@implementation UserCheckInCell
@synthesize textLabel=_textLabel;
@synthesize checkBtn=_checkBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-PHOTO_FRAME_WIDTH*5, self.frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.text = @"| 您已连续签到10天";
        
        [self addSubview:_textLabel];

        //
        _checkBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.backgroundColor =[UIColor blueColor];
        _checkBtn.frame=CGRectMake(SCREENWITH -PHOTO_FRAME_WIDTH- 50, PHOTO_FRAME_WIDTH, 50, 30);
        _checkBtn.titleLabel.font =FONT(13);
        [_checkBtn setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        [self addSubview:_checkBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)dealloc
{
    
    self.actionBlock=nil;
    self.data=nil;
    self.indexPath=nil;
    self.other=nil;
    self.key=nil;
}

-(void)setCallBack:(void(^)(BEventType,UIView*,id,id,NSIndexPath *))callback
{
    self.actionBlock =callback;
}
- (void)showInfo:(id)model other:(id)other key:(id)key indexPath:(NSIndexPath *)indexPath
{
    self.data =model;
    self.key =key;
    self.other=other;
    self.indexPath=indexPath;
}
/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model
{
    return 50;
}

@end
