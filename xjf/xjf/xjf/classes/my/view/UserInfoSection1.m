//
//  UserInfoSection1.m
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoSection1.h"

@interface UserInfoSection1 ()
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIView *placeView;
@property (weak, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *age;
@end

@implementation UserInfoSection1

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *views = @[_sexView,_placeView,_ageView];
    for (UIView *view in views) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [view addGestureRecognizer:tap];
    }
}
- (void)viewClicked:(UITapGestureRecognizer *)gesture {
    NSLog(@"%ld",gesture.view.tag);
}
-(void)setModel:(UserProfileModel *)model {
    _model = model;
    _sex.text = _model.result.sex==1?@"男":(_model.result.sex==2?@"女":@"未知");
    _sex.text = _model.result.city==nil||_model.result.age.length==0?@"未知":_model.result.city;
    _age.text = _model.result.age==nil||_model.result.age.length==0?@"未知":_model.result.age;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
