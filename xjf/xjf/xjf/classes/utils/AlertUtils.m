//
//  AlertUtils.m
//  QCColumbus
//
//  Created by Chen on 15/6/2.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "AlertUtils.h"
#import "XJAccountManager.h"
#import "UserInfoInterestedCell.h"
#import <objc/runtime.h>
@interface AlertUtils () <UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UIView *caseView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) Case type;
@property (nonatomic, strong) UITableView *tableview;
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

#define CASE_WIDTH 250
#define CASE_HEIGHT 300

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
            self.dataSource = [NSMutableArray arrayWithArray:@[@"股票",@"债券",@"基金",@"期货",@"外汇",@"保险",@"银行理财",@"贵金属",@"其它"]];
            [self confirmCaseView:InterestedInvestCase size:CGSizeMake(CASE_WIDTH, CASE_HEIGHT) title:@"修改感兴趣的金融知识"];
        }
            break;
        case ExperienceInvestCase:
        {
            self.dataSource = [NSMutableArray arrayWithArray:@[@"小于三个月",@"小于一年",@"一年至两年",@"两年至三年",@"三年至四年",@"五年至十年",@"十年以上"]];
            [self confirmCaseView:ExperienceInvestCase size:CGSizeMake(CASE_WIDTH, CASE_HEIGHT) title:@"设置投资资历"];
        }
            break;
        case PreferenceInvestCase:
        {
            self.dataSource = [NSMutableArray arrayWithArray:@[@"稳健产品",@"年化收益小于20%",@"年化收益达30%至50%",@"年化收益50%以上"]];
            [self confirmCaseView:PreferenceInvestCase size:CGSizeMake(CASE_WIDTH, CASE_HEIGHT) title:@"设置投资偏好"];
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
    if (type!=InterestedInvestCase) {
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
    }else {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 38, size.width-20, size.height-34-38) style:UITableViewStylePlain];
        self.tableview.delegate = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview.dataSource = self;
        self.tableview.showsVerticalScrollIndicator = NO;
        [self.tableview registerNib:[UINib nibWithNibName:@"UserInfoInterestedCell" bundle:nil] forCellReuseIdentifier:@"UserInfoInterestedCell"];
        [self.caseView addSubview:self.tableview];
        if (self.handler(nil)) {
            NSString *txt = self.handler(nil);
            if (txt) {
                objc_setAssociatedObject(self.tableview, @"content", txt, OBJC_ASSOCIATION_COPY_NONATOMIC);
            }
        }
    }
    NSArray *titles = @[@"取消",@"确定"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.caseView.alpha = 1;
        self.background.alpha = 0.3;
        self.caseView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:nil];
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
    NSString *txt = nil;
    if (self.type == InterestedInvestCase) {
        txt = objc_getAssociatedObject(self.tableview, @"content");
    }else {
        txt = [self.dataSource objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    [self hiddenCaseView];
    if (button.tag==781) {
        if (self.handler) self.handler(txt);
    }
    [self hiddenCaseView];
}
#pragma mark - PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
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
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoInterestedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoInterestedCell"];
    cell.content.text = [self.dataSource objectAtIndex:indexPath.row];
    NSMutableArray *array = [self getTableViewContentArray];
    for (NSString *str in array) {
        if ([str isEqualToString:cell.content.text]) {
            [cell makeSelected];
            break;
        }else {
            [cell makeDeSelected];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoInterestedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell resetMarkSelected:^(NSString *txt) {
        NSString *text = objc_getAssociatedObject(self.tableview, @"content");
        if (text==nil) {
            text = [NSString stringWithFormat:@"%@",txt];
        }else {
            text = [NSString stringWithFormat:@"%@/%@",text,txt];
        }
        objc_setAssociatedObject(self.tableview, @"content", text, OBJC_ASSOCIATION_COPY_NONATOMIC);
    } cancelSelected:^(NSString *txt) {
        NSMutableArray *array = [self getTableViewContentArray];
        [array removeObject:txt];
        NSString *tableContent = nil;
        for (NSString *str in array) {
            if (array.count==1) {
                tableContent = str;
            }else {
                if (tableContent==nil) {
                    tableContent = [NSString stringWithFormat:@"%@",str];
                }else {
                    tableContent = [NSString stringWithFormat:@"%@/%@",tableContent,str];
                }
            }
        }
        objc_setAssociatedObject(self.tableview, @"content", tableContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }];
}
- (NSMutableArray *)getTableViewContentArray {
    NSString *text = objc_getAssociatedObject(self.tableview, @"content");
    NSMutableArray *array = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@"/"]];
    return array;
}
@end
