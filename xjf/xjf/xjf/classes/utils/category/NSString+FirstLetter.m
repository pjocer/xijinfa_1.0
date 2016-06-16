//
//  NSString+FirstLetter.m
//  xjf
//
//  Created by PerryJ on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "NSString+FirstLetter.h"

@implementation NSString (FirstLetter)
- (NSString *)firstLetter {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
@end
