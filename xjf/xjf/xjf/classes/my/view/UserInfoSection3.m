//
//  UserInfoSection3.m
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoSection3.h"

@interface UserInfoSection3 ()
@property (weak, nonatomic) IBOutlet UIView *interested_invest;
@property (weak, nonatomic) IBOutlet UIView *experience_invest;
@property (weak, nonatomic) IBOutlet UIView *preference_invest;
@property (weak, nonatomic) IBOutlet UILabel *interested;
@property (weak, nonatomic) IBOutlet UILabel *experience;
@property (weak, nonatomic) IBOutlet UILabel *preference;
@end

@implementation UserInfoSection3

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *views = @[_interested_invest,_experience_invest,_preference_invest];
    for (UIView *view in views) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [view addGestureRecognizer:tap];
    }
}
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",tap.view.tag);
}
-(void)setModel:(UserProfileModel *)model {
    _model = model;
    _interested.text = _model.result.invest_type==nil||_model.result.invest_type.length==0?@"未知":_model.result.invest_type;
    _experience.text = _model.result.invest_age==nil||_model.result.invest_age.length==0?@"未知":_model.result.invest_age;
    _preference.text = _model.result.invest_category==nil||_model.result.invest_category.length==0?@"未知":_model.result.invest_category;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
