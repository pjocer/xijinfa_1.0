//
//  SelectedView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectedViewCompletionHandler)(id data);


@interface SelectedView : XJFBaseView
typedef NS_OPTIONS(NSUInteger, SelectedViewType) {
    ISSchool,   // 学堂
    ISEmployed  // 从业
};
@property (nonatomic, strong) NSString *leftButtonName;
@property (nonatomic, strong) NSString *rightButtonName;
@property (nonatomic, strong) NSMutableArray <NSString *>*tableDataSource;
@property (nonatomic, strong) NSMutableArray <NSString *>*testTableDataSource;
@property(nullable, nonatomic, copy) SelectedViewCompletionHandler handlerData;
- (instancetype)initWithFrame:(CGRect)frame
             SelectedViewType:(SelectedViewType)selectedViewType NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@end
NS_ASSUME_NONNULL_END