//
//  LoadingView.m
//  QCColumbus
//
//  Created by Chen on 15/4/24.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "LoadingView.h"
#import "AppDelegateManager.h"

#define DEFAULT_ICON_HEIGHT 74
#define DEFAULT_ICON_WIDTH 97
#define FAILED_VERTICAL_OFFSET 20
#define EMPTY_VERTICAL_OFFSET 30
#define EMPTY_VERTICAL_SUB_OFFSET 10

@interface LoadingView ()

@end

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)showLoading {
    [self removeAllSubviews];
    self.hidden = NO;
    UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 60) / 2, (self.height - 60) / 2, 60, 60)];
    [loadingImageView setImage:[UIImage imageNamed:@"recharge_failed"]];// Default Image 暂缺
    [self addSubview:loadingImageView];
    [self runSpinAnimationOnView:loadingImageView duration:NSIntegerMax repeat:YES];
}

- (void)showLoadingFailed{
    if ([AppDelegateManager sharedInstance].currentStatus == NetworkDisconnection) {
        [self showLoadingFailedWithErrorType:ErrorTypeNetWorkDisconnection];
    }else{
        [self showLoadingFailedWithErrorType:ErrorTypeDefault];
    }
}

- (void)showLoadingFailedWithErrorType:(ErrorType)errorType{
    if (errorType == ErrorTypeNetWorkDisconnection) {
        [self showLoadingFailedWithTitle:@"网络异常，请检查网络设置" ErrorType:ErrorTypeNetWorkDisconnection];
    }else{
        [self showLoadingFailedWithTitle:@"网络异常，请稍后重试" ErrorType:ErrorTypeDefault];
    }
}

- (void)showLoadingFailedWithTitle:(NSString *)title ErrorType:(ErrorType)errorType{
    [self removeAllSubviews];
    self.hidden = NO;
    UIImage *image;
    if (errorType == ErrorTypeNetWorkDisconnection) {
        // 网络未连接 暂缺
        image = [UIImage imageNamed:@"recharge_failed"];
    }else{
        // Normal LoadingFailedIcon 暂缺
        image = [UIImage imageNamed:@"recharge_failed"];
    }
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = AssistColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.centerY.equalTo(self).offset(50);
        make.height.equalTo(@15);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(titleLabel.mas_top).offset(-10);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
    }];
    
    if (errorType == ErrorTypeDefault) {
        UIButton *refreshButton = [[UIButton alloc]init];
        refreshButton.backgroundColor = [UIColor whiteColor];
        refreshButton.layer.borderWidth = 1;
        refreshButton.layer.borderColor = BlueColor.CGColor;
        refreshButton.layer.cornerRadius = 5;
        refreshButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [refreshButton setTitleColor:BlueColor forState:UIControlStateNormal];
        [refreshButton addTarget:self action:@selector(didRefreshButtonCilcked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refreshButton];
        [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleLabel.mas_bottom).offset(17);
            make.width.equalTo(@68);
            make.height.equalTo(@28);
        }];
    }

}

- (void)showLoadingEmptyWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle{
    [self showLoadingEmptyWithIcon:icon title:title subTitle:subTitle titleLabelCenterY:30.f];
}

- (void)showLoadingEmptyWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle titleLabelCenterY:(CGFloat)titleLabelCenterY{
    [self removeAllSubviews];
    UIImage *image = [UIImage imageNamed:icon];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView setImage:image];
    [iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:iconImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = AssistColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.centerY.equalTo(self).offset(titleLabelCenterY);
        make.height.equalTo(@15);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(titleLabel.mas_top).offset(-10);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
    }];

    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = AssistColor;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];

    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didEmptyViewTouched)];
    [iconImageView addGestureRecognizer:tapGeture];
}

- (void)showLoadingEmptyWithType:(EmptyType)type {
    self.hidden = NO;
    switch (type) {
        case EmptyTypeComment:
        {
            
        }
            break;
            
        default:
            break;
    }
}
// Run spin animation by CA
- (void)runSpinAnimationOnView:(UIView *)view duration:(CGFloat)duration repeat:(float)repeat;
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0 * duration];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    rotationAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)removeAllSubviews {
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
}

- (void)didEmptyViewTouched {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadingEmptyViewTouched)]) {
        [self.delegate didLoadingEmptyViewTouched];
    }
}

- (void)didRefreshButtonCilcked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRefreshButtonCilcked)]) {
        [self.delegate didRefreshButtonCilcked];
    }
}

@end
