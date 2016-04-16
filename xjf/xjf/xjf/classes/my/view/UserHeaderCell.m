//
//  UserHeaderCell.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserHeaderCell.h"
@interface UserHeaderCell()
{
    
}
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *iconView;

@property(nonatomic,strong)UILabel *nameLabel;
@end
@implementation UserHeaderCell
@synthesize bgView=_bgView;
@synthesize iconView=_iconView;
@synthesize nameLabel=_nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        _bgView.image = [UIImage imageNamed:@"user_bg.png"];
        [self addSubview:_bgView];
        //
        _iconView =[[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.frame = CGRectMake((SCREENWITH-80)/2,20, 80, 80);
        _iconView.layer.cornerRadius=40;
        _iconView.layer.masksToBounds = YES;
        _iconView.userInteractionEnabled =YES;
        _iconView.image =[UIImage imageNamed:@"my_user.png"];
        [self addSubview:_iconView];
        //
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.frame.origin.y+_iconView.frame.size.height + 10, self.frame.size.width, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.text = @"析金小白";
        [self addSubview:_nameLabel];
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
    return 200;
}


@end
