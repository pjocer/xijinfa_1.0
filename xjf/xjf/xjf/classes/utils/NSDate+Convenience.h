//
//  NSDate+Convenience.h
//  QCColumbus
//
//  Created by chenxiaojie on 15/7/3.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)hour;
- (NSInteger)day;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)weekday;
//1,周几；2，星期几
- (NSString *)weekdayString:(NSInteger)transferType;

- (BOOL)laterThanCompareMonth:(NSDate *)date;
- (BOOL)laterThanCompareDay:(NSDate *)date;
- (BOOL)laterThanCompareMinute:(NSDate *)date;
- (BOOL)isSameTime:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isSameDay:(NSDate *)date;

- (NSString *)dateStringWithHourAndMinute;
- (NSString *)dateStringWithHyphen;
- (NSString *)dateStringWithMonth;
- (NSString *)dateStringWithPoint;
- (NSString *)hyphenStringWithHourAndMinute;
- (NSString *)chineseDateString;

- (NSString *)yearAndMonthString;
- (NSString *)yearAppendMonth;

+ (NSDate *)dateFromHourString:(NSString *)dateString;
+ (NSDate *)dateFromPointString:(NSString *)dateString;
+ (NSDate *)dateFromHyphenString:(NSString *)dateString;
+ (NSDate *)dateFromPointHourString:(NSString *)dateString;

- (NSDate *)cutDateToMonth;
- (NSDate *)cutDateToDay;
- (NSDate *)cutDateToMinute;
- (NSDate *)offsetDay:(NSInteger)numDays;
- (NSDate *)offsetMonth:(NSInteger)months;
- (NSInteger)monthBetweenDates:(NSDate *)date;
- (NSInteger)daysBetweenDates:(NSDate *)date;
- (NSInteger)weeksBetweenDates:(NSDate *)date;
+ (NSDate *)dateFromYear:(NSInteger)year andMonth:(NSInteger)month;
+ (NSInteger)daysInYear:(NSInteger)year andMonth:(NSInteger)month;
@end
