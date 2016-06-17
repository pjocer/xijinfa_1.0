//
//  NSDate+Convenience.m
//  QCColumbus
//
//  Created by chenxiaojie on 15/7/3.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "NSDate+Convenience.h"

@implementation NSDate (Convenience)
#pragma mark - date components

- (NSInteger)year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSInteger)month {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    return components.month;
}

- (NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];
    return components.minute;
}

- (NSInteger)second {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self];
    return components.second;
}

- (NSInteger)weekday {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return components.weekday;
}

- (NSString *)weekdayString:(NSInteger)transferType {
    if (transferType == 1) {
        switch ([self weekday]) {
            case 1:
                return @"周日";
                break;
            case 2:
                return @"周一";
                break;
            case 3:
                return @"周二";
                break;
            case 4:
                return @"周三";
                break;
            case 5:
                return @"周四";
                break;
            case 6:
                return @"周五";
                break;
            case 7:
                return @"周六";
                break;
            default:
                return @"";
                break;
        }
    }
    else {
        switch ([self weekday]) {
            case 1:
                return @"星期天";
                break;
            case 2:
                return @"星期一";
                break;
            case 3:
                return @"星期二";
                break;
            case 4:
                return @"星期三";
                break;
            case 5:
                return @"星期四";
                break;
            case 6:
                return @"星期五";
                break;
            case 7:
                return @"星期六";
                break;
            default:
                return @"";
                break;
        }
    }
}

#pragma mark - date compare

- (BOOL)laterThanCompareMonth:(NSDate *)date {
    NSComparisonResult result = [[self cutDateToMonth] compare:[date cutDateToMonth]];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)laterThanCompareDay:(NSDate *)date {
    NSComparisonResult result = [[self cutDateToDay] compare:[date cutDateToDay]];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)laterThanCompareMinute:(NSDate *)date {
    NSComparisonResult result = [[self cutDateToMinute] compare:[date cutDateToMinute]];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)isToday {
    return [[self cutDateToDay] isEqualToDate:[[NSDate date] cutDateToDay]];
}

- (BOOL)isSameDay:(NSDate *)date {
    return [[self cutDateToDay] isEqualToDate:[date cutDateToDay]];
}

- (BOOL)isSameTime:(NSDate *)date {
    return [[self cutDateToMinute] isEqualToDate:[[NSDate date] cutDateToMinute]];
}

#pragma mark - date and string transfer

+ (NSDate *)dateFromPointHourString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromHourString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromHyphenString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromPointString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringWithHourAndMinute {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)hyphenStringWithHourAndMinute {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateStringWithHyphen {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateStringWithMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateStringWithPoint {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)chineseDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)yearAndMonthString {
    return [NSString stringWithFormat:@"%ld年%.2ld月", (unsigned long) [self year], (unsigned long) [self month]];
}

- (NSString *)yearAppendMonth {
    return [NSString stringWithFormat:@"%ld-%.2ld", (unsigned long) [self year], (unsigned long) [self month]];
}

#pragma mark - date calculation

- (NSDate *)cutDateToMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)cutDateToDay {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)cutDateToMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)offsetDay:(NSInteger)numDays {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                         toDate:self options:0];
}

+ (NSInteger)daysInYear:(NSInteger)year andMonth:(NSInteger)month {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                return 29;
            }
            else {
                return 28;
            }
        default:
            return 0;
            break;
    }
}

- (NSDate *)offsetMonth:(NSInteger)months {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:months];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                         toDate:self options:0];
}

- (NSInteger)monthBetweenDates:(NSDate *)date {
    return 12 * (date.year - self.year) + date.month - self.month;
}

- (NSInteger)weeksBetweenDates:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear fromDate:self];
    NSDateComponents *selectedComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    if (selectedComponents.year == components.year) {
        return selectedComponents.weekOfYear - components.weekOfYear;
    }
    else {
        NSInteger totalWeeks = 0;
        NSInteger year = MIN(selectedComponents.year, components.year);
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = year;
            components.month = 1;
            components.day = 1;
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
            NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
            if (weekdayComponents.weekday == 0) {
                totalWeeks = 54;
            }
            else {
                totalWeeks = 53;
            }
        }
        else {
            totalWeeks = 53;
        }
        if (selectedComponents.year > components.year) {
            if (components.weekOfYear == 1 && components.month == 12) {
                return selectedComponents.weekOfYear - 1;
            }
            return (selectedComponents.weekOfYear + totalWeeks - components.weekOfYear);
        }
        else {
            if (selectedComponents.weekOfYear == 1 && selectedComponents.month == 12) {
                return 1 - components.weekOfYear;
            }
            return (selectedComponents.weekOfYear - totalWeeks - components.weekOfYear + 1);
        }
    }
}

- (NSInteger)daysBetweenDates:(NSDate *)date {
    NSDate *startDate = [self dateByAddingTimeInterval:-3600 * self.hour - 60 * self.minute - self.second];
    NSDate *endDate = [date dateByAddingTimeInterval:-3600 * date.hour - 60 * date.minute - date.second];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    return (int) ceil(interval / (3600 * 24)) + 1;
}

+ (NSDate *)dateFromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
@end
