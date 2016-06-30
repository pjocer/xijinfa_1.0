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
#import "PhotoHandler.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface UserInfoCell () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *nickname;
@property (weak, nonatomic) IBOutlet UIButton *introduce;
@end

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 75 / 2.0;
    _avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction)];
    [_avatar addGestureRecognizer:tap];
    // Initialization code
}
- (void)avatarAction {
    UIViewController *controller = getCurrentDisplayController();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PhotoHandler *handler = [[PhotoHandler alloc] initWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary imagePickerDelegate:self];
        [handler show];
    }];
    [alert addAction:album];
    UIAlertAction *photograph = [UIAlertAction actionWithTitle:@"拍摄上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PhotoHandler *handler = [[PhotoHandler alloc] initWithSourceType:UIImagePickerControllerSourceTypeCamera imagePickerDelegate:self];
        [handler show];
    }];
    [alert addAction:photograph];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:YES completion:nil];
}
- (void)setModel:(UserProfileModel *)model {
    _model = [[XJAccountManager defaultManager] user_model];
    if (!_avatar.image) {
        [_avatar sd_setImageWithURL:[NSURL URLWithString:_model.result.avatar]];
    }
    [_nickname setTitle:_model.result.nickname forState:UIControlStateNormal];
    [_introduce setTitle:_model.result.quote == nil || _model.result.quote.length == 0 ? @"一句话介绍你自己（兴趣/职业）" : _model.result.quote forState:UIControlStateNormal];
}

- (IBAction)nicknameAction:(UIButton *)sender {
    UIViewController *controller = getCurrentDisplayController();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.placeholder = @"请输入新的昵称";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UITextField *textFiled = [alert.textFields objectAtIndex:0];
        if (textFiled.text.length > 0) {
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
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.placeholder = @"请输入新的个人简介";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UITextField *textFiled = [alert.textFields objectAtIndex:0];
        if (textFiled.text.length > 0) {
            [self.introduce setTitle:textFiled.text forState:UIControlStateNormal];
        }
        if (self.SummaryBlock) self.SummaryBlock(textFiled.text);
    }];
    [alert addAction:determine];
    [controller presentViewController:alert animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        CGFloat percent = image.size.width*1.0f/image.size.height*1.0f;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200*percent, 200), NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, 200*percent, 200)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData* imageData = UIImageJPEGRepresentation(image,0.1);
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"user_icon.jpg"];
        [imageData writeToFile:fullPathToFile atomically:NO];
        NSURL *imageURL = [NSURL fileURLWithPath:fullPathToFile];
        self.avatar.image = image;
        if (self.AvatarBlock) {
            if (self.AvatarBlock (image,imageURL) == YES) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请上传正确的图片"];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
