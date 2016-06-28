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
    NSMutableString *str = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}
@end
