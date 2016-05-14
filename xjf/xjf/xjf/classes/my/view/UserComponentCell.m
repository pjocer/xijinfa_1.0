//
//  UserComponentCell.m
//  xjf
//
//  Created by PerryJ on 16/5/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserComponentCell.h"
#import "UzysGridView.h"

@interface UserComponent : UzysGridViewCell
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation UserComponent

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 25, 25)];
        [self addSubview:_icon];
        self.icon.center = self.center;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 40)];
        [self addSubview:_titleLabel];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.center = CGPointMake(CGRectGetMaxX(_icon.frame), CGRectGetMaxY(_icon.frame)+10);
        self.titleLabel.font = FONT13;
        
    }
    return self;
}
 -(void)setImage:(UIImage *)image {
    _image = image;
    _icon.image = image;
    [self bringSubviewToFront:_icon];
}
-(void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    [self bringSubviewToFront:_titleLabel];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = CGRectMake(40,45, 25, 25);
    _titleLabel.frame = CGRectMake(40, 5, 16, 40);
}
@end

@interface UserComponentCell () <UzysGridViewDelegate,UzysGridViewDataSource,UzysGridViewCellDelegate>
@property (nonatomic, strong)NSMutableArray *images;
@property (nonatomic, strong)NSMutableArray *titles;
@end

@implementation UserComponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UzysGridView *gridView = [[UzysGridView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) numOfRow:3 numOfColumns:4 cellMargin:1];
        gridView.delegate = self;
        gridView.dataSource = self;
        [self addSubview:gridView];
    }
    return self;
}
-(NSInteger) numberOfCellsInGridView:(UzysGridView *)gridview {
    return 12;
}
-(UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index {
    UserComponent *component = [[UserComponent alloc]initWithFrame:CGRectNull];
    component.deletable = NO;
    if (index != 11) {
        UIImage *image = [UIImage imageNamed:self.images[index]];
        component.image = image;
        component.title = self.titles[index];
    }
    return component;
}
-(void) gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index {
    
}
-(NSMutableArray *)images {
    if (_images == nil || !_images) {
        _images = [NSMutableArray arrayWithCapacity:11];
        NSArray *image = @[@"user_lesson",@"user_teacher",@"user_topic",@"user_answer",@"user_history",@"user_faovrite",@"user_purse",@"user_cart",@"user_download",@"user_check",@"user_feedback"];
        [_images addObjectsFromArray:image];
    }
    return _images;
}
-(NSMutableArray *)titles {
    if (_titles == nil || !_titles) {
        _titles = [NSMutableArray arrayWithCapacity:11];
        NSArray *title = @[@"我的课堂",@"我的老师",@"我的话题",@"我的回答",@"播放记录",@"我的收藏",@"我的钱包",@"购物车",@"我的缓存",@"每日签到",@"反馈意见"];
        [_titles addObjectsFromArray:title];
    }
    return _titles;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
