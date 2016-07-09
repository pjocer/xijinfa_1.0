//
//  LoadingView.h
//  QCColumbus
//
//  Created by Chen on 15/4/24.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Custom EmptyType 
 */
typedef enum {
    EmptyTypeComment,
} EmptyType;
/**
 *  Error Type
 */
typedef NS_ENUM(NSInteger, ErrorType) {
    /**
     *  Network Disconnection
     */
    ErrorTypeNetWorkDisconnection = 0,
    /**
     *  Bind Empty Type
     */
    ErrorTypeDefault,
};

@protocol LoadingDelegate <NSObject>
@optional
/**
 *  Call back when empty view did clicked
 */
- (void)didLoadingEmptyViewTouched;
/**
 *  Call back when refresh button did clicked
 */
- (void)didRefreshButtonCilcked;

@end

@interface LoadingView : UIView
@property (nonatomic, weak) id<LoadingDelegate> delegate;

/**
 *  Show default loading animation
 */
- (void)showLoading;
/**
 *  Show default loading failed
 */
- (void)showLoadingFailed;
/**
 *  Show loading failed by error type
 *
 *  @param errorType ErrorType contaiend ErrorTypeNetWorkDisconnection | ErrorTypeDefault
 */
- (void)showLoadingFailedWithErrorType:(ErrorType)errorType;
/**
 *  Show loading empty with empty type
 *
 *  @param type Custom empty type in enum EmptyType
 */
- (void)showLoadingEmptyWithType:(EmptyType)type;
/**
 *  Show loading empty with custom content
 *
 *  @param icon     Custom image
 *  @param title    Custom title
 *  @param subTitle Custom subtitle
 */
- (void)showLoadingEmptyWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle;

@end
