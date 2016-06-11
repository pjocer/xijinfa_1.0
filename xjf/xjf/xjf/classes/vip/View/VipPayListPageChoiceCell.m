//
//  VipPayListPageChoiceCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VipPayListPageChoiceCell.h"

@interface VipPayListPageChoiceCell ()
@property (nonatomic, strong) UILabel *vipDescribe;
@end

@implementation VipPayListPageChoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //backGroudView
        self.backGroudView = [[UIView alloc] init];
        [self.contentView addSubview:self.backGroudView];
        self.backGroudView.layer.borderWidth = 1;
        [self.backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-5);
        }];
        
        //selectedLabel;
        self.selectedLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.selectedLabel];
        [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backGroudView);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        self.selectedLabel.layer.borderWidth = 1;
        self.selectedLabel.layer.masksToBounds = YES;
        self.selectedLabel.layer.cornerRadius = 7;
        
        //vipDescribe;
        self.vipDescribe = [[UILabel alloc] init];
        [self.contentView addSubview:self.vipDescribe];
        [self.vipDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backGroudView);
            make.left.equalTo(self.backGroudView).with.offset(15);
            make.right.equalTo(self.selectedLabel.mas_left).with.offset(-10);
            make.height.mas_equalTo(18);
        }];
        self.vipDescribe.font = FONT15;
    }
    return self;
}

- (void)setModel:(VipModel *)model
{
    if (model) {
        _model = model;
    }
    
    NSString *tempPeriod;
    if ([model.period isEqualToString:@"1m"]) {
       tempPeriod = @"一个月:";
    } else if ([model.period isEqualToString:@"1y"]){
       tempPeriod = @"一年:";
    }
    
    self.vipDescribe.attributedText = [self.vipDescribe changeColorWithString:[NSString stringWithFormat:@"%@ %@",tempPeriod,[NSString stringWithFormat:@"￥%.2lf",[model.price floatValue] / 100]] light:[NSString stringWithFormat:@"￥%.2lf",[model.price floatValue] / 100] Font:15 Color:[UIColor redColor]];
}

@end
