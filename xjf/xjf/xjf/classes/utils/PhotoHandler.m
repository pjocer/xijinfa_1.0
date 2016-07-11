//
//  PhotoHandler.m
//  xjf
//
//  Created by PerryJ on 16/6/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PhotoHandler.h"
#import <Photos/Photos.h>
#import "XJAccountManager.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface PhotoHandler ()
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIViewController *currentDisplayed;
@property (nonatomic, assign) UIImagePickerControllerSourceType type;
@end

@implementation PhotoHandler
- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)type imagePickerDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate{
    self = [super init];
    if (self) {
        _type = type;
        [self initProperties];
        self.imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        self.imagePicker.delegate = delegate;
        self.currentDisplayed = getCurrentDisplayController();
    }
    return self;
}
- (void)initProperties {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = self.type;
}
-(void)show {
    [self.currentDisplayed.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}
@end
