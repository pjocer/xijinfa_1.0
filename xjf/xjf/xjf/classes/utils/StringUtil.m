//
//  StringUtil.m
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+(NSString *)compareCurrentTime:(NSString *)compareDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:compareDate];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString
                  stringWithFormat:@"%ld年前",temp];
    }
    return  result;
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
+(NSArray *)handleTime:(NSArray<NSString *> *)times {
    [times sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedAscending;
    }];
    return times;
}
@end
