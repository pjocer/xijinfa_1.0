//
//  UserInfoSection2.m
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoSection2.h"

@interface UserInfoSection2 ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@end

@implementation UserInfoSection2

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [_view addGestureRecognizer:tap];
    // Initialization code
}
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",tap.view.tag);
}
-(void)setModel:(UserProfileModel *)model {
    _model = model;
    _phone.text = _model.result.phone==nil||_model.result.phone.length==0?@"未知":_model.result.phone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
