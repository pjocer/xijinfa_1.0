//
//  AlertUtils.m
//  QCColumbus
//
//  Created by Chen on 15/6/2.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "AlertUtils.h"
#import "XJAccountManager.h"

@interface AlertUtils () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UIView *caseView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) Case type;
@property (nonatomic, copy) id (^handler)(NSString *);
@end

@implementation AlertUtils

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmBlock:(dispatch_block_t)confirmBlock{
   [self alertWithTarget:target
                   Title:title
                 content:content
            confirmTitle:@"确定"
             cancelTitle:@"取消"
             cancelBlock:nil
            confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
           confirmBlock:(dispatch_block_t)confirmBlock{
   [self alertWithTarget:target
                   Title:title
                 content:content
            confirmTitle:confirmTitle
             cancelTitle:cancelTitle
             cancelBlock:nil
            confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
            cancelBlock:(dispatch_block_t)cancelBlock
           confirmBlock:(dispatch_block_t)confirmBlock{
    [self alertWithTarget:target
                    Title:title
                  content:content
             confirmTitle:confirmTitle
              cancelTitle:cancelTitle
              cancelBlock:cancelBlock
             confirmBlock:confirmBlock];
}

+ (void)alertWithTarget:(UIViewController *)target
                  Title:(NSString *)title
                content:(NSString *)content
           confirmTitle:(NSString *)confirmTitle
            cancelTitle:(NSString *)cancelTitle
            cancelBlock:(dispatch_block_t)cancelBlock
           confirmBlock:(dispatch_block_t)confirmBlock{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:content
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        if(cancelTitle.length > 0){
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:cancelTitle
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action) {
                if(cancelBlock){
                   cancelBlock();
                }
            }];
            [alertController  addAction:cancelAction];
        }
        
        UIAlertAction *confirmAction = [UIAlertAction
                                        actionWithTitle:confirmTitle
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
            if(confirmBlock){
               confirmBlock();
            }
        }];
        [alertController  addAction:confirmAction];
        
        [target presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertWithTarget:(UIViewController *)target
                  title:(NSString *)title
                okTitle:(NSString *)okTitle
             otherTitle:(NSString *)otherTitle
      cancelButtonTitle:(NSString *)cancelButtonTitle
                message:(NSString *)message
            cancelBlock:(dispatch_block_t)cancelBlock
                okBlock:(dispatch_block_t)okBlock
             otherBlock:(dispatch_block_t)otherBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (okBlock) {
            okBlock();
        }
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (otherBlock) {
            otherBlock();
        }
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:otherAction];
    
    [target presentViewController:alertController animated:YES completion:nil];
}

#define CASE_WIDTH 200
#define CASE_HEIGHT 250

-(void)showChoose:(Case)type handler:(id (^)(id txt))ChooseCaseHandler{
    self.handler = ChooseCaseHandler;
    self.type = type;
    self.window = [[UIApplication sharedApplication] keyWindow];
    switch (type) {
        case AgeCase:
        {
            self.dataSource = [NSMutableArray arrayWithObjects:@"18-22岁",@"23-30岁",@"31-40岁",@"41-50岁",@"51-60岁",@"61-70岁",@">70岁", nil];
            [self confirmCaseView:AgeCase size:CGSizeMake(CASE_WIDTH, CASE_HEIGHT) title:@"设置年龄"];
        }
            break;
        case SexCase:
        {
            self.dataSource = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
            [self confirmCaseView:SexCase size:CGSizeMake(CASE_WIDTH, CASE_HEIGHT) title:@"设置性别"];
        }
            break;
        case InterestedInvestCase:
        {
            
        }
            break;
        case ExperienceInvestCase:
        {
            
        }
            break;
        case PreferenceInvestCase:
        {
            
        }
            break;
        default:
            break;
    }
}
- (void)confirmCaseView:(Case)type size:(CGSize)size title:(NSString *)title{
    self.background = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.background.backgroundColor = [UIColor blackColor];
    self.background.alpha = 0;
    self.caseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.caseView.backgroundColor = [UIColor whiteColor];
    self.caseView.center = self.window.center;
    self.caseView.alpha = 0;
    self.caseView.layer.cornerRadius = 5;
    self.caseView.layer.masksToBounds = YES;
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width-20, 18)];
    titleLable.font = FONT15;
    titleLable.textColor = NormalColor;
    titleLable.text = title;
    [self.caseView addSubview:titleLable];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 38, size.width-20, size.height-34-38)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    if (self.handler(nil)) {
        NSString *txt = self.handler(nil);
        if (txt) {
            for (int i = 0; i < self.dataSource.count; i++) {
                if ([txt isEqualToString:[self.dataSource objectAtIndex:i]]) {
                    [self.picker selectRow:i inComponent:0 animated:YES];
                }
            }
        }
    }
    [self.caseView addSubview:self.picker];
    NSArray *titles = @[@"取消",@"确定"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(size.width/2*i, size.height-28, size.width/2, 18)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleColor:UIControlContentHorizontalAlignmentCenter forState:UIControlStateNormal];
        button.tag = 780+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.caseView addSubview:button];
    }
    [self.window addSubview:self.background];
    [self.window addSubview:self.caseView];
    [self showCaseView];
}
- (void)showCaseView {
    [UIView animateWithDuration:0.1 animations:^{
        self.caseView.alpha = 0.66;
        self.background.alpha = 0.3;
        self.caseView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.caseView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.caseView.alpha = 1;
        } completion:nil];
    }];
}
- (void)hiddenCaseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.background.alpha = 0;
        self.caseView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];
        [self.caseView removeFromSuperview];
    }];
}
- (void)buttonAction:(UIButton *)button {
    NSString *txt = [self.dataSource objectAtIndex:[self.picker selectedRowInComponent:0]];
    [self hiddenCaseView];
    if (button.tag==781) {
        if (self.handler) self.handler(txt);
    }
    [self hiddenCaseView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.type == AgeCase||self.type == SexCase) {
        return 1;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CASE_WIDTH-20;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label==nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CASE_WIDTH-20, 30)];
        label.font = FONT15;
        label.textAlignment = 1;
        label.textColor = NormalColor;
    }
    label.text = [self.dataSource objectAtIndex:row];
    return label;
}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"%@",[self.dataSource objectAtIndex:row]);
//}
@end
