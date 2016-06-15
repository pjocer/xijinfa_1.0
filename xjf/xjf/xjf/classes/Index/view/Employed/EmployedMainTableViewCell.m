//
//  EmployedMainTableViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedMainTableViewCell.h"
@interface EmployedMainTableViewCell ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;
///分割线
@property (nonatomic, strong) UIView *customSeparator;
@end


@implementation EmployedMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        //separator
        self.customSeparator = [[UIView alloc] init];
        self.customSeparator.backgroundColor = BackgroundColor;
        [self.contentView addSubview:self.customSeparator];
        
        //titleImage
        self.titleImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.titleImage];
        self.titleImage.backgroundColor = BackgroundColor;
        
        //titleLable
        self.titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLable];
        self.titleLable.textColor = [UIColor xjfStringToColor:@"#444444"];
        self.titleLable.font = FONT15;
        
        //detailLable
        self.detailLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.detailLable];
        self.detailLable.textColor = [UIColor xjfStringToColor:@"#9a9a9a"];
        self.detailLable.font = FONT12;

        //layout
        //separator
        [self.customSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).with.offset(-1);
            make.height.mas_equalTo(1);
        }];
        
        //titleImage
        [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(55, 55));
            
        }];

        //titleLable
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImage.mas_right).with.offset(15);
            make.right.equalTo(self.contentView).with.offset(-30);
            make.bottom.mas_equalTo(self.titleImage.mas_centerY);
            make.height.mas_equalTo(15);
        }];

        //detailLable
        [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable);
            make.size.mas_equalTo(self.titleLable);
            make.top.mas_equalTo(self.titleLable.mas_bottom).with.offset(9);
        }];

    }
    return self;
}

- (void)setModel:(ProjectList *)model {
    if (model) {
        _model = model;
    }
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLable.text = model.title;
    self.detailLable.text = model.summary;
}
@end
