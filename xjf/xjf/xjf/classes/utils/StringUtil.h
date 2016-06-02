//
//  StringUtil.h
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DeleteCostKey @"deleteCost"
#define AddCostKey @"addCost"
#define MoveCostKey @"moveCost"
#define EditCostKey @"editCost"
#define AddScheduleKey @"addSchedule"
#define EditScheduleKey @"EditScheduleKey"
#define RequestStatusChangeKey @"requestStatusChanged"
#define ChooseScheduleTypeKey @"chooseScheduleType"
#define UpdateRedDotKey @"updateRedDot"
#define ReorderKey @"reorder"
#define CancelOrderKey @"cancelOrder"
#define AddEditCost @"AddNewCostVC"
#define AddEditSchedule @"AddNewScheduleVC"

@interface StringUtil : NSObject

+ (CGFloat)calculateLabelHeight:(NSString *)content width:(float)width fontsize:(float)fontsize;
+ (CGRect)calculateLabelRect:(NSString *)content width:(float)width fontsize:(float)fontsize;
+ (CGRect)calculateLabelRect:(NSString *)content size:(CGSize)size font:(UIFont *)font;
+ (CGRect)calculateLabelRect:(NSString *)content height:(float)height fontSize:(float)fontsize;
+(NSString *) compareCurrentTime:(NSString *) compareDate;

@end
