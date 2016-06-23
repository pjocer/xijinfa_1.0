//
//  StringUtil.m
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *)compareCurrentTime:(NSString *)compareDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:compareDate];
    long t = -(long) [date timeIntervalSinceNow]; // long is big enough
    if (t < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    } else if ((t = t / 60) < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", t];
    } else if ((t = t / 60) < 24) {
        return [NSString stringWithFormat:@"%ld小时前", t];
    } else if ((t = t / 24) < 30) {
        return [NSString stringWithFormat:@"%ld天前", t];
    } else if ((t = t / 30) < 12) {
        return [NSString stringWithFormat:@"%ld月前", t];
    } else {
        return [NSString stringWithFormat:@"%ld年前", t / 12];
    }
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
    NSInteger options = NSStringDrawingUsesFontLeading
            | NSStringDrawingTruncatesLastVisibleLine
            | NSStringDrawingUsesLineFragmentOrigin;
    return [content boundingRectWithSize:size options:(NSStringDrawingOptions) options attributes:attributes context:nil];
}

+ (CGRect)calculateLabelRect:(NSString *)content height:(float)height fontSize:(float)fontsize {
    return [self calculateLabelRect:content size:CGSizeMake(MAXFLOAT, height) font:[UIFont systemFontOfSize:fontsize]];
}

+ (NSArray *)handleTime:(NSArray<NSString *> *)times {
    [times sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return NSOrderedAscending;
    }];
    return times;
}

@end
