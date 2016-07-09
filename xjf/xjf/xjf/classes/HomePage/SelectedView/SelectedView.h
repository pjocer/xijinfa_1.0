//
//  SelectedView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseView.h"
#import "ProjectListByModel.h"

NS_ASSUME_NONNULL_BEGIN

///reloadData
typedef void (^SelectedViewCompletionHandler)(id data);


@interface SelectedView : XJFBaseView
typedef NS_OPTIONS(NSUInteger, SelectedViewType) {
    ISSchool,   // 学堂
    ISEmployed  // 从业
};
@property (nonatomic, strong) NSString *leftButtonName;
@property (nonatomic, strong) NSString *rightButtonName;
@property(nullable, nonatomic, copy) SelectedViewCompletionHandler handlerData;
@property (nonatomic, strong) ProjectListByModel *projectListByModel_Employed;
@property (nonatomic, strong) NSDictionary *employedDataDic;

- (instancetype)initWithFrame:(CGRect)frame
             SelectedViewType:(SelectedViewType)selectedViewType NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

