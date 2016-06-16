//
//  UserInfoSection1.m
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoSection1.h"
#import "AlertUtils.h"
#import "XJAccountManager.h"
#import "CitySelecter.h"

@interface UserInfoSection1 ()
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIView *placeView;
@property (weak, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) AlertUtils *alert;

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
    self.alert = [AlertUtils new];
    switch (gesture.view.tag) {
        case 770:
        {
            [self confirmResult:SexCase];
        }
            break;
        case 771:
        {
            UIViewController *controller = getCurrentDisplayController();
            [controller.navigationController pushViewController:[CitySelecter new] animated:YES];
        }
            break;
        case 772:
        {
            [self confirmResult:AgeCase];
        }
            break;
        default:
            break;
    }
}
- (void)confirmResult:(Case)type {
    [self.alert showChoose:type handler:^id(id txt) {
        UILabel *label = type==SexCase?self.sex:(type==AgeCase?self.age:self.place);
        if (txt) {
            label.text = txt;
            void (^block) (NSString *txt) = type==SexCase?self.SexBlock:(type==AgeCase?self.AgeBlock:self.CityBlock);
            if (block) block (txt);
        }
        return label.text;
    }];
}
-(void)setModel:(UserProfileModel *)model {
    _model = model;
    _sex.text = _model.result.sex==1?@"男":(_model.result.sex==2?@"女":@"未知");
    _place.text = _model.result.city==nil||_model.result.city.length==0?@"未知":_model.result.city;
    _age.text = _model.result.age==nil||_model.result.age.length==0?@"未知":_model.result.age;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
