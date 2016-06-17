//
//  BaseViewCell.h
//  xjf
//
//  Created by liuchengbin on 16/4/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xjfConfigure.h"
#import "RTLabel.h"
#import "NSString+Extensions.h"
#import "UILabel+StringFrame.h"
#import "UIImageView+WebCache.h"

typedef enum {
    BEventType_Unknow,
    BEventType_More,//更多
} BEventType;

@interface BaseViewCell : UITableViewCell

@property (nonatomic, strong) id data;
@property (nonatomic, strong) id key;
@property (nonatomic, strong) id other;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^actionBlock)(BEventType, UIView *, id, id, NSIndexPath *);

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback;

/// 根据数据模型来显示内容
- (void)showInfo:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)showInfo:(id)model other:(id)other indexPath:(NSIndexPath *)indexPath;

- (void)showInfo:(id)model other:(id)other key:(id)key indexPath:(NSIndexPath *)indexPath;

/// 根据key模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath;

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model;

@end
