//
//  StringUtil.m
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil
+ (NSString *)getDateText:(NSString *)startDate andEnd:(NSString *)endDate {
    startDate = [self formatDateWithoutMinutes:startDate];
    endDate = [self formatDateWithoutMinutes:endDate];
    
    return [NSString stringWithFormat:@"%@-%@", startDate, endDate];
}

+ (NSString *)formatMinutesString:(NSString *)startDate andEnd:(NSString *)endDate
{
    startDate = [self deformatDateString:startDate];
    startDate = [startDate stringByReplacingCharactersInRange:NSMakeRange(startDate.length - 1, 1) withString:@"0"];
    endDate = [self deformatDateString:endDate];
    endDate = [endDate stringByReplacingCharactersInRange:NSMakeRange(endDate.length - 1, 1) withString:@"0"];
    return [NSString stringWithFormat:@"%@-%@", startDate, endDate];
}

+ (NSString *)formatDateWithoutMinutes:(NSString *)date{
    date = [self deformatDateString:date];
    if ([date rangeOfString:@" "].location != NSNotFound) {
        date = [date substringToIndex:[date rangeOfString:@" "].location];
    }
    return date;
}

+ (NSString *)deformatDateString:(NSString *)dateString
{
    if ([dateString rangeOfString:@"-"].location == NSNotFound) {
        return dateString;
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    return dateString;
}

+ (NSString *)formatDateString:(NSString *)dateString
{
    if ([dateString rangeOfString:@"."].location == NSNotFound) {
        return dateString;
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    return dateString;
}

+ (NSString *)getDateStringComponentDate:(NSString *)dateString
{
    NSParameterAssert(dateString);
    
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    NSString *date = array.count > 0 ? array.firstObject : nil;
    return date;
}

+ (NSString *)getDateStringComponentTime:(NSString *)dateString
{
    NSParameterAssert(dateString);
    
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    NSString *time = array.count > 1 ? array.lastObject : nil;
    return time;
}

+ (CGFloat)calculateLabelHeight:(NSString *)content width:(float)width fontsize:(float)fontsize {
    CGRect rect = [self calculateLabelRect:content size:CGSizeMake(width, MAXFLOAT) font:[UIFont systemFontOfSize:fontsize]];
    return rect.size.height;
}

+ (CGRect)calculateLabelRect:(NSString *)content width:(float)width fontsize:(float)fontsize {
    return [self calculateLabelRect:content size:CGSizeMake(width, MAXFLOAT) font:[UIFont systemFontOfSize:fontsize]];
}

+ (CGRect)calculateLabelRect:(NSString *)content size:(CGSize)size font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [content boundingRectWithSize:size options:(NSStringDrawingOptions)options attributes:attributes context:nil];
}

+ (CGRect)calculateLabelRect:(NSString *)content height:(float)height fontSize:(float)fontsize {
    return [self calculateLabelRect:content size:CGSizeMake(MAXFLOAT, height) font:[UIFont systemFontOfSize:fontsize]];
}

+ (BOOL)isEmpty:(NSString *)string
{
    if (string.length == 0 || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)formatDecimalData:(double)data withDecimalCount:(NSInteger)count needSeperator:(BOOL)needSeperator
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setMaximumFractionDigits:count];
    [numberFormatter setMinimumIntegerDigits:1];
    if (needSeperator) {
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:data]];
    return string;
}

+ (NSString *)formatDecimalDataString:(NSNumber *)data withDecimalCount:(NSInteger)count needSeperator:(BOOL)needSeperator
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setMaximumFractionDigits:count];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    if (needSeperator) {
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSString *string = [numberFormatter stringFromNumber:data];
    
    return string;
}

+ (NSString *)formatMoneyString:(double)price maximumFractionDigits:(int)maximumFractionDigits needSeperator:(BOOL)needSeperator{
    // (5*100000000.0/offset)为可保证能进位的最大偏移值，如99500000为能保证小数点后显示2位，并正常进位1亿的偏移
    int offset = pow(10, maximumFractionDigits);
    
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.8lf",price]];
    if (fabs(price) >= (100000000.0-5*10000.0/offset)) {
        NSDecimalNumber *divide = [NSDecimalNumber decimalNumberWithString:@"100000000.00000000"];
        value = [value decimalNumberByDividingBy:divide];
    }else if (fabs(price) >= (10000.0-5/offset)) {
        NSDecimalNumber *divide = [NSDecimalNumber decimalNumberWithString:@"10000.00000000"];
        value = [value decimalNumberByDividingBy:divide];
    }
    
    NSString *string = [StringUtil formatDecimalDataString:value withDecimalCount:maximumFractionDigits needSeperator:NO];
    
    if(fabs(price) >= (100000000.0-5*100000000.0/offset)){
        return [NSString stringWithFormat:@"%@亿",string];
    }
    if (fabs(price) >= (10000.0-5*10000.0/offset)){
        return [NSString stringWithFormat:@"%@万",string];
    }
    return string;
}

+ (NSString *)formatHomeMoneyString:(double)price
{
    double value = price;
    if(fabs(value)  >= 10000000){
        value /= 100000000;
    }
    if (fabs(value) >= 1000) {
        value /= 10000;
    }
    
    if (fabs(price) < 1000) {
        NSString *string = [StringUtil formatDecimalData:value withDecimalCount:2 needSeperator:NO];
        return string;
    }
    if (fabs(price) < 10000000 && fabs(price) >= 1000) {
        NSString *string = [StringUtil formatDecimalData:value withDecimalCount:2 needSeperator:NO];
        return [NSString stringWithFormat:@"%@万",string];;
    }
    if (fabs(price) >= 10000000) {
        NSString *string = [StringUtil formatDecimalData:value withDecimalCount:2 needSeperator:NO];
        return [NSString stringWithFormat:@"%@亿",string];
    }
    return @"";
}

+ (NSString *)formatFloatValueToPercentValue:(double)price maximumFractionDigits:(int)maximumFractionDigits{
    NSString *string = [StringUtil formatDecimalData:price * 100 withDecimalCount:maximumFractionDigits needSeperator:NO];
    return [string stringByAppendingString:@"%"];
}

+ (BOOL)isValidatePhone:(NSString *)phoneNum
{
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phonePredicate evaluateWithObject:phoneNum];
}

+ (NSString *)getMonthFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%ld月", (long)components.month];
}

+ (NSString *)stringFromSelectDate:(NSDate *)date{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [inputFormatter stringFromDate:date];
}
@end
