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
+ (NSString *)getDateText:(NSString *)startDate andEnd:(NSString *)endDate;
+ (NSString *)formatDateWithoutMinutes:(NSString *)date;
+ (NSString *)getDateStringComponentDate:(NSString *)dateString;
+ (NSString *)getDateStringComponentTime:(NSString *)dateString;
+ (NSString *)formatMinutesString:(NSString *)startDate andEnd:(NSString *)endDate;
+ (NSString *)formatDateString:(NSString *)dateString;
+ (NSString *)getMonthFromString:(NSString *)dateString;
+ (NSString *)getDayTimeString:(NSString *)string;
+ (NSString *)deformatDateString:(NSString *)dateString;
+ (NSString *)formatHomeMoneyString:(double)price;
+ (NSString *)formatMoneyString:(double)price maximumFractionDigits:(int)maximumFractionDigits needSeperator:(BOOL)needSeperator;
//格式化百分比
+ (NSString *)formatFloatValueToPercentValue:(double)price maximumFractionDigits:(int)maximumFractionDigits;

+ (NSString *)formatDecimalData:(double)data withDecimalCount:(NSInteger)count needSeperator:(BOOL)needSeperator;
+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)isValidatePhone:(NSString *)phoneNum;

+ (NSString *)formatSelectStackItemWithMonth:(NSString *)title departmentName:(NSString *)departmentName itemType:(TrendType)type;
+ (NSString *)stringFromSelectDate:(NSDate *)date;

@end
