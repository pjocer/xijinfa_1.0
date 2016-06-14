//
//  UserInfoCell.m
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoCell.h"
#import "UIImageView+WebCache.h"
#import "XJAccountManager.h"

@interface UserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *nickname;
@property (weak, nonatomic) IBOutlet UIButton *introduce;

@end

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 75/2.0;
    _avatar.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(UserProfileModel *)model {
    _model = model;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_model.result.avatar]];
    [_nickname setTitle:_model.result.nickname forState:UIControlStateNormal];
    [_introduce setTitle:_model.result.summary==nil||_model.result.summary.length==0?@"一句话介绍你自己（兴趣/职业）":_model.result.summary forState:UIControlStateNormal];
}
- (IBAction)nicknameAction:(UIButton *)sender {
    UIViewController *controller = getCurrentDisplayController();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.placeholder = @"请输入新的昵称";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textFiled = [alert.textFields objectAtIndex:0];
        if (textFiled.text.length>0) {
            [self.nickname setTitle:textFiled.text forState:UIControlStateNormal];
        }
        if (self.NicknameBlock) self.NicknameBlock(textFiled.text);
    }];
    [alert addAction:determine];
    [controller presentViewController:alert animated:YES completion:nil];
}
- (IBAction)summaryAction:(UIButton *)sender {
    UIViewController *controller = getCurrentDisplayController();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改简介" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.placeholder = @"请输入新的个人简介";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textFiled = [alert.textFields objectAtIndex:0];
        if (textFiled.text.length>0) {
            [self.introduce setTitle:textFiled.text forState:UIControlStateNormal];
        }
        if (self.SummaryBlock) self.SummaryBlock(textFiled.text);
    }];
    [alert addAction:determine];
    [controller presentViewController:alert animated:YES completion:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
